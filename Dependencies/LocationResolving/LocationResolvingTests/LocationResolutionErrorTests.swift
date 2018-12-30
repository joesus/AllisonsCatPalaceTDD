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
        let errors: Set<LocationResolutionError> = [
            .locationNotFound,
            .disallowed,
            .unknown
        ]
        let cases = Set(LocationResolutionError.allCases)

        XCTAssertEqual(errors, cases,
                       "There should be three types of errors")
    }

}
