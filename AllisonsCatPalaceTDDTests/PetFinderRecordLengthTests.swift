//
//  PetFinderRecordLengthTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderRecordLengthTests: XCTestCase {

    func testAllCases() {
        switch PetFinderRecordLength.short {
        case .short, .long:
            break
        }
    }

    func testStringRepresentation() {
        XCTAssertEqual(PetFinderRecordLength.short.description, "basic",
                       "The string representation should be 'basic'")
        XCTAssertEqual(PetFinderRecordLength.long.description, "full",
                       "The string representation should be 'full'")
    }

    func testQueryItem() {
        var expected = URLQueryItem(
            name: PetFinderUrlBuilder.BaseQueryItemKeys.recordLength,
            value: PetFinderRecordLength.short.description
        )

        XCTAssertEqual(PetFinderRecordLength.short.queryItem, expected,
                       "A record length should be expressible as a URL query item")

        expected = URLQueryItem(
            name: PetFinderUrlBuilder.BaseQueryItemKeys.recordLength,
            value: PetFinderRecordLength.long.description
        )

        XCTAssertEqual(PetFinderRecordLength.long.queryItem, expected,
                       "A record length should be expressible as a URL query item")
    }

}
