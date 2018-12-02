//
//  LocationManaging.swift
//  LocationResolverTests
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation

protocol LocationManaging {
    var delegate: CLLocationManagerDelegate? { get set }

    static func locationServicesEnabled() -> Bool
    static func authorizationStatus() -> CLAuthorizationStatus

    func requestWhenInUseAuthorization()
    func requestAlwaysAuthorization()

    func requestLocation()
}

extension CLLocationManager: LocationManaging {}
