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

    lazy var locationManager: LocationManaging = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    var geocoder: Geocoding = CLGeocoder()

    private var resolvedLocationHandler: ((UserLocationResolution) -> Void)?

    public var userLocationResolution: UserLocationResolution {
        guard type(of: locationManager).locationServicesEnabled() else {
            return .disallowed
        }

        switch type(of: locationManager).authorizationStatus() {
        case .notDetermined: return .unknown
        case .denied: return .disallowed
        case .authorizedWhenInUse, .authorizedAlways: return .allowed
        default: return .unknown
        }
    }

    public func requestLocationAuthorization(for availability: LocationUpdateAvailability) {
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

    public func resolveUserLocation(completion: @escaping (UserLocationResolution) -> Void) {
        guard resolvedLocationHandler == nil else {
            completion(.resolutionFailed(error: .requestInProgress))
            return
        }

        resolvedLocationHandler = completion
        locationManager.requestLocation()
    }

    public func findPlacemark(for searchTerm: String, completion: @escaping (CLPlacemark?) -> Void) {
        geocoder.geocodeAddressString(searchTerm) { potentialPlacemarks, potentialError in
            var placemark: CLPlacemark?
            defer { completion(placemark) }

            guard potentialError == nil else { return }

            placemark = potentialPlacemarks?.first
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
            guard potentialError == nil,
                let placemark = potentialPlacemarks?.last
                else {
                    self.resolvedLocationHandler?(.resolutionFailed(error: .unknown))
                    return
            }

            self.resolvedLocationHandler?(
                .resolved(placemark: placemark)
            )

            self.resolvedLocationHandler = nil
        }
    }
}
