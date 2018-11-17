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
             .unknownError,
             .missingPostalCode,
             .invalidPostalCode:
            return
        }
    }

    func testErrorMessages() {
        XCTAssertEqual(
            LocationResolutionError.noLocationsFound.message,
            "We were unable to find your location",
            "The message for no locations found should be correct"
        )
        XCTAssertEqual(
            LocationResolutionError.missingPostalCode.message,
            "We were unable to find a postal code for your location",
            "The message for a missing postal code should be correct"
        )
        XCTAssertEqual(
            LocationResolutionError.invalidPostalCode.message,
            "We were unable to use the postal code for your location",
            "The message for an invalid postal code should be correct"
        )
        XCTAssertEqual(
            LocationResolutionError.unknownError.message,
            "We were unable to find your location",
            "The message for an unknown error should be correct"
        )
    }

}
