//
//  LocationResolutionTests.swift
//  LocationResolvingTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import LocationResolving
import CoreLocation
import XCTest

class LocationResolutionTests: XCTestCase {

    let placemark = SamplePlacemarks.denver

    func testAllCases() {
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark),
            .resolutionFailed(error: .unknown)
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolved, .resolutionFailed:
                break
            }
        }
    }

    func testEquatability() {
        let firstSet: [LocationResolution] = [
            .resolved(placemark: placemark),
            .resolutionFailed(error: .unknown)
        ]

        let secondSet: [LocationResolution] = [
            .resolved(placemark: placemark),
            .resolutionFailed(error: .unknown)
        ]

        zip(firstSet, secondSet).forEach { pair in
            let (firstState, secondState) = pair

            XCTAssertEqual(firstState, secondState,
                           "\(firstState) should equal \(secondState)")
        }
    }

    func testResolvedInequality() {
        XCTAssertNotEqual(
            LocationResolution.resolved(placemark: placemark),
            .resolved(placemark: SamplePlacemarks.vancouver),
            "Resolved location with differing placemarks should not be considered equal"
        )
    }

    func testFailureInequality() {
        XCTAssertNotEqual(
            LocationResolution.resolutionFailed(error: .noLocationsFound),
            .resolutionFailed(error: .unknown),
            "Resolution failures with different errors should not be considered equal"
        )
    }

    func testError() {
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark),
            .resolutionFailed(error: .unknown)
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolved:
                XCTAssertNil(value.error,
                             "Resolution states that do not have an associated error should not provide an error")

            case .resolutionFailed(let error):
                XCTAssertEqual(value.error, error,
                               "Resolution failures should provide their associated error")
            }
        }
    }

    func testPlacemark() {
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark),
            .resolutionFailed(error: .unknown)
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolutionFailed:
                XCTAssertNil(value.placemark,
                             "Resolution states that do not have an associated placemark should not provide a placemark")

            case .resolved(let placemark):
                XCTAssertEqual(value.placemark, placemark,
                               "Resolution success should provide its associated placemark")
            }
        }

    }
}
