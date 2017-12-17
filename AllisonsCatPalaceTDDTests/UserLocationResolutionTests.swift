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
            .allowed,
            .disallowed,
            .resolving,
            .resolved(location: SamplePlacemarks.denver),
            .resolutionFailure(error: SampleError())
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
