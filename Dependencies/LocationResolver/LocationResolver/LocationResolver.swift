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

    var locationManager: LocationManaging!
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

    init(locationManager: LocationManaging = CLLocationManager()) {
        super.init()

        self.locationManager = locationManager
        self.locationManager.delegate = self
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
        resolvedLocationHandler = completion
        locationManager.requestLocation()
        // TODO
    }

    public func findPlacemark(for: String, completion: (CLPlacemark?) -> Void) {
        // TODO
    }

    public func cancelAllRequests() {
        // TODO
    }
}

extension LocationResolver: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // geocode {
        //     capturedHandler
        // }
    }
}
