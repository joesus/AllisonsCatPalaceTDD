//
//  CatPalaceErrorTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatNetworkErrorTests: XCTestCase {

    var error: CatNetworkError!

    func testCatNetworkErrorCases() {
        error = .missingCatService
        switch error! {
            case .missingCatService,
                 .missingCat(_),
                 .missingData:
                return
        }
    }

    func testMissingCatService() {
        error = .missingCatService
        switch error! {
        case .missingCatService:
            XCTAssertEqual(error.message, "Cat service unavailable")
            return
        default:
            XCTFail("error should be a missingCat error")
        }
    }

    func testMissingCat() {
        error = .missingCat(identifier: 15)
        switch error! {
        case .missingCat:
            XCTAssertEqual(error.message, "Cat 15 not found", "message for missingCat error should include correct identifier")
            return
        default:
            XCTFail("error should be a missingCat error")
        }
    }

    func testMissingData() {
        error = .missingData
        switch error! {
        case .missingData:
            XCTAssertEqual(error.message, "Missing Data", "message for missingData error should be 'Missing Data'")
        default:
            XCTFail("error should be a missingData error")
        }
    }
}
