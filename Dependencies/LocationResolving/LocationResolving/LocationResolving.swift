//
//  LocationResolving.swift
//  LocationResolving
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation

public protocol LocationResolving {
    var userLocationResolution: UserLocationResolution { get }

    func requestLocationAuthorization(for availability: LocationUpdateAvailability)
    func resolveUserLocation(completion: @escaping (UserLocationResolution) -> Void)
    func findPlacemark(for: String, completion: (CLPlacemark?) -> Void)
    func cancelAllRequests()
}
