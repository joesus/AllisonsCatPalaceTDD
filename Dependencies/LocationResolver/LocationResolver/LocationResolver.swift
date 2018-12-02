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

    public var userLocationResolution: UserLocationResolution {
        if !type(of: locationManager).locationServicesEnabled() {
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
        // TODO
    }

    public func resolveUserLocation(completion: (UserLocationResolution) -> Void) {
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

}
