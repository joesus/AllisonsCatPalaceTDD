//
//  PositiveIntegerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class PositiveIntegerTests: XCTestCase {

    func testCannotCreatePositiveIntegerWithMinInt() {
        XCTAssertNil(PositiveInteger(Int.min),
                     "Cannot create a positive integer with a negative value")
    }

    func testCannotCreatePositiveIntegerWithNegativeInt() {
        XCTAssertNil(PositiveInteger(-1),
                     "Cannot create a positive integer with a negative value")
    }

    func testCannotCreatePositiveIntegerWithZero() {
        XCTAssertNil(PositiveInteger(0),
                     "Cannot create a positive integer with zero")
    }

    func testCanCreatePositiveIntegerWithPositiveInt() {
        guard let value = PositiveInteger(1) else {
            return XCTFail("Should create a positive integer with a positive value")
        }
        XCTAssertEqual(value.value, 1,
                       "Should create positive integer with correct value")
    }

    func testCanCreatePositiveIntegerWithMaxInt() {
        guard let value = PositiveInteger(Int.max) else {
            return XCTFail("Should create a positive integer with a positive value")
        }
        XCTAssertEqual(value.value, Int.max,
                       "Should create positive integer with correct value")

    }
}
