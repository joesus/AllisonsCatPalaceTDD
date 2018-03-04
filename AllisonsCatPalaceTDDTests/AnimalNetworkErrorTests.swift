//
//  CatPalaceErrorTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class AnimalNetworkErrorTests: XCTestCase {

    var error: AnimalNetworkError!

    func testAnimalNetworkErrorCases() {
        error = .missingAnimalService
        switch error! {
        case .missingAnimalService,
             .missingAnimal,
             .missingData:
            return
        }
    }

    func testMissingAnimalService() {
        error = .missingAnimalService
        switch error! {
        case .missingAnimalService:
            XCTAssertEqual(error.message, "Animal service unavailable")
            return
        default:
            XCTFail("error should be a missingCat error")
        }
    }

    func testMissingAnimal() {
        error = .missingAnimal(identifier: 15)
        switch error! {
        case .missingAnimal:
            XCTAssertEqual(error.message, "Animal 15 not found",
                           "message for missingAnimal error should include correct identifier")
            return
        default:
            XCTFail("error should be a missingAnimal error")
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
