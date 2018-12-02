//
//  FakeLocationManager.swift
//  LocationResolverTests
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation
@testable import LocationResolver

class FakeLocationManager: NSObject, LocationManaging {
    var delegate: CLLocationManagerDelegate?

    static var stubbedLocationServicesEnabled = true
    class func locationServicesEnabled() -> Bool {
        return stubbedLocationServicesEnabled
    }

    static var stubbedAuthorizationStatus = CLAuthorizationStatus.notDetermined
    class func authorizationStatus() -> CLAuthorizationStatus {
        return stubbedAuthorizationStatus
    }

    class func reset() {
        stubbedLocationServicesEnabled = true
        stubbedAuthorizationStatus = .notDetermined
    }
}
