//
//  LocationUpdateAvailabilityTests.swift
//  LocationResolvingTests
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import XCTest
import LocationResolving

class LocationUpdateAvailabilityTests: XCTestCase {

    func testAllCases() {
        switch LocationUpdateAvailability.whenInUse {
        case .always,
             .whenInUse:
            return
        }
    }
}
