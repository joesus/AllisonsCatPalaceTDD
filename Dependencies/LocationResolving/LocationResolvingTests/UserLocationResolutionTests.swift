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

    func testEquatability() {
        let firstSet: [UserLocationResolution] = [
            .unknown,
            .allowed,
            .disallowed,
            .resolving,
            .resolved(placemark: placemark),
            .resolutionFailure(error: .unknownError)
        ]

        let secondSet: [UserLocationResolution] = [
            .unknown,
            .allowed,
            .disallowed,
            .resolving,
            .resolved(placemark: placemark),
            .resolutionFailure(error: .unknownError)
        ]

        zip(firstSet, secondSet).forEach { pair in
            let (firstState, secondState) = pair

            XCTAssertEqual(firstState, secondState,
                           "\(firstState) should equal \(secondState)")
        }
    }

    func testResolvedInequality() {
        XCTAssertNotEqual(
            UserLocationResolution.resolved(placemark: placemark),
            .resolved(placemark: SamplePlacemarks.vancouver),
            "Resolved location with differing placemarks should not be considered equal"
        )
    }

    func testFailureInequality() {
        XCTAssertNotEqual(
            UserLocationResolution.resolutionFailure(error: .noLocationsFound),
            .resolutionFailure(error: .unknownError),
            "Resolution failures with different errors should not be considered equal"
        )
    }
}
