//
//  LocationResolving.swift
//  LocationResolving
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation

public protocol LocationResolutionDelegate: class {
    func didResolveLocation(_ location: LocationResolution)
}

public protocol LocationResolving {
    var delegate: LocationResolutionDelegate? { get set }

    var userLocationResolvability: UserLocationResolvability { get }
    var locationResolution: LocationResolution? { get }

    func requestUserLocationAuthorization(for availability: UserLocationUpdateAvailability)
    func resolveUserLocation()
    func findPlacemark(for: String)
}
