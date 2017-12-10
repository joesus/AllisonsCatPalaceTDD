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
            .unknown,
            .resolving,
            .resolved(location: SamplePlacemark.denver),
            .resolutionFailure(error: SampleError()),
            .blocked
         ]

        possibleValues.forEach { value in
            switch value {
            case .unknown,
                 .resolving,
                 .resolved,
                 .resolutionFailure,
                 .blocked:
                break
            }
        }
    }
}
