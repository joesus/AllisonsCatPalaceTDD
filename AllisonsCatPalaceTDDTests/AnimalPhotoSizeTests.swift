//
//  AnimalPhotoSizeTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalPhotoSizeTests: XCTestCase {

    func testAllCases() {
        let sizes = [AnimalPhotoSize.small, .medium, .large]

        sizes.forEach { size in
            switch size {
            case .small, .medium, .large:
                break
            }
        }
    }

    func testInitializingWithEmptyString() {
        XCTAssertNil(AnimalPhotoSize(petFinderRawValue: ""),
                     "Should not create photo size from empty string")
    }

    func testCannotInitializeWithInvalidStrings() {
        let invalidStrings = ["fpm", "pnt"]

        invalidStrings.forEach { string in
            XCTAssertNil(AnimalPhotoSize(petFinderRawValue: string),
                         "Should not create photo size from: \(string)")
        }
    }

    func testInitializingWithValidStrings() {
        let validStrings = ["x", "t", "pn"]

        validStrings.forEach { string in
            XCTAssertNotNil(AnimalPhotoSize(petFinderRawValue: string),
                            "Should create photo size from: \(string)")
        }
    }
}
