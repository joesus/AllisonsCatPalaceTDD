//
//  LocationResolver.swift
//  LocationResolver
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation
import LocationResolving

public class LocationResolver: NSObject, LocationResolving {

    public weak var delegate: LocationResolutionDelegate?

    public var userLocationResolvability: UserLocationResolvability {
        guard type(of: locationManager).locationServicesEnabled() else {
            return .disallowed
        }

        switch type(of: locationManager).authorizationStatus() {
        case .notDetermined: return .unknown
        case .denied, .restricted: return .disallowed
        case .authorizedWhenInUse, .authorizedAlways: return .allowed
        default: return .unknown
        }
    }

    var isResolvingLocation = false
    public var locationResolution: LocationResolution?

    lazy var locationManager: LocationManaging = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    var geocoder: Geocoding = CLGeocoder()

    public func requestUserLocationAuthorization(for availability: UserLocationUpdateAvailability) {
        guard type(of: locationManager).locationServicesEnabled(),
            type(of: locationManager).authorizationStatus() == .notDetermined
            else {
                return
        }

        switch availability {
        case .whenInUse: locationManager.requestWhenInUseAuthorization()
        case .always: locationManager.requestAlwaysAuthorization()
        }
    }

    public func resolveUserLocation() {
        guard !isResolvingLocation else { return }

        isResolvingLocation = true
        locationManager.requestLocation()
    }

    public func resolveLocation(for searchTerm: String) {
        guard !isResolvingLocation else { return }

        isResolvingLocation = true
        geocoder.geocodeAddressString(searchTerm) { potentialPlacemarks, potentialError in
            let resolution: LocationResolution
            defer {
                self.delegate?.didResolveLocation(resolution)
                self.locationResolution = resolution
                self.isResolvingLocation = false
            }

            guard potentialError == nil else {
                resolution = .resolutionFailed(error: .unknown, date: Date())
                return
            }

            guard let placemark = potentialPlacemarks?.first else {
                resolution = .resolutionFailed(error: .locationNotFound, date: Date())
                return
            }

            resolution = .resolved(placemark: placemark, date: Date())
        }
    }

}

extension LocationResolver: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            assertionFailure("Delegate callback is guaranteed to receive at least one location object")
            return
        }

        geocoder.reverseGeocodeLocation(location) { potentialPlacemarks, potentialError in
            let resolution: LocationResolution
            defer {
                self.delegate?.didResolveLocation(resolution)
                self.locationResolution = resolution
                self.isResolvingLocation = false
            }

            guard potentialError == nil,
                let placemark = potentialPlacemarks?.last
                else {
                    resolution = .resolutionFailed(error: .unknown, date: Date())
                    return
            }

            resolution = .resolved(placemark: placemark, date: Date())
        }
    }
}
