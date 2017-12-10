//
//  UserLocationResolutionTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AllisonsCatPalaceTDD

class UserLocationResolutionTests: XCTestCase {

    func testAllCases() {
        let possibleValues: [UserLocationResolution] = [
            .resolved(location: SamplePlacemark.denver),
            .resolving,
            .resolutionFailure(error: SampleError()),
            .blocked,
            .geocodeFailure(error: SampleError())
         ]

        possibleValues.forEach { value in
            switch value {
            case .resolved,
                 .resolving,
                 .resolutionFailure,
                 .blocked,
                 .geocodeFailure:
                break
            }
        }
    }
}
