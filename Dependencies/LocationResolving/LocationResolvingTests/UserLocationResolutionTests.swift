//
//  UserLocationResolutionTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import LocationResolving
import CoreLocation
import XCTest

class UserLocationResolutionTests: XCTestCase {

    let placemark = SamplePlacemarks.denver

    func testAllCases() {
        let possibleValues: [UserLocationResolution] = [
            .unknown,
            .allowed,
            .disallowed,
            .resolving,
            .resolved(placemark: placemark),
            .resolutionFailure(error: .unknownError)
         ]

        possibleValues.forEach { value in
            switch value {
            case .unknown,
                 .allowed,
                 .disallowed,
                 .resolving,
                 .resolved,
                 .resolutionFailure:
                break
            }
        }
    }
}
