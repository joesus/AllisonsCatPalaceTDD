//
//  SpeciesSelectionIndexTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/3/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class SpeciesSelectionIndexTests: XCTestCase {

    func testCatIndex() {
        guard let catIndex = SpeciesSelectionIndex(rawValue: 0) else {
            return XCTFail("Index 0 should map to a known species index")
        }

        XCTAssertEqual(catIndex, .cat,
                       "Index 0 should refer to the Cat segment")
    }

    func testDogIndex() {
        guard let dogIndex = SpeciesSelectionIndex(rawValue: 1) else {
            return XCTFail("Index 1 should map to a known species index")
        }

        XCTAssertEqual(dogIndex, .dog,
                       "Index 1 should refer to the Dog segment")
    }

    func testAnyIndex() {
        guard let anyIndex = SpeciesSelectionIndex(rawValue: 2) else {
            return XCTFail("Index 2 should map to a known species index")
        }

        XCTAssertEqual(anyIndex, .any,
                       "Index 2 should refer to the Any segment")
    }

    func testOutOfRangeIndices() {
        XCTAssertNil(SpeciesSelectionIndex(rawValue: 3),
                     "An out of range value should not create a valid species selection index")
        XCTAssertNil(SpeciesSelectionIndex(rawValue: -1),
                     "An out of range value should not create a valid species selection index")
    }
}
