//
//  LocationResolutionErrorTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import LocationResolving

class LocationResolutionErrorTests: XCTestCase {

    func testGeocodingErrorCases() {
        switch LocationResolutionError.noLocationsFound {
        case .noLocationsFound,
             .requestInProgress,
             .unknown:
            return
        }
    }

    func testErrorMessages() {
        XCTAssertEqual(
            LocationResolutionError.noLocationsFound.userFacingMessage,
            "We were unable to find your location",
            "The message for no locations found should be correct"
        )
        XCTAssertEqual(
            LocationResolutionError.requestInProgress.userFacingMessage,
            "Finding your location",
            "The message for an unknown error should be correct"
        )
        XCTAssertEqual(
            LocationResolutionError.unknown.userFacingMessage,
            "We were unable to find your location",
            "The message for an unknown error should be correct"
        )
    }

    func testEquality() {
        let errors = [
            LocationResolutionError.noLocationsFound,
            .requestInProgress,
            .unknown
        ]

        XCTAssertEqual(errors, errors,
                       "Synthesized equatability should be used")
    }

}
