//
//  LocationResolutionErrorTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest

@testable import AllisonsCatPalaceTDD

class LocationResolutionErrorTests: XCTestCase {

    var error: LocationResolutionError!

    func testGeocodingErrorCases() {
        error = .noLocationsFound
        switch error! {
        case .noLocationsFound,
             .unknownError:
            return
        }
    }

    func testNoLocationsFound() {
        error = .noLocationsFound
        switch error! {
        case .noLocationsFound:
            XCTAssertEqual(error.message, "We can't find that zip code, did you enter it right?",
                           "message for no locations found should be correct")
            return
        default:
            XCTFail("error should be a noLocationsFound error")
        }
    }

    func testUnknownError() {
        error = .unknownError
        switch error! {
        case .unknownError:
            XCTAssertEqual(error.message, "We misplaced our atlas, please try again.",
                           "message for unknown error should be correct")
        default:
            XCTFail("error should be an unknownError error")
        }
    }
}
