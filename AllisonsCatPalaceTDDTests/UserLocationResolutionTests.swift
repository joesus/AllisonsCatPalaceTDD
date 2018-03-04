//
//  UserLocationResolutionTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import CoreLocation
import XCTest

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
