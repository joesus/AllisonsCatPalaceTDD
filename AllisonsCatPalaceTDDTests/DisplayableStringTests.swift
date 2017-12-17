//
//  DisplayableStringTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/17/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class DisplayableStringTests: XCTestCase {

    func testUndisplayableString() {
        let strings = ["", " ", "\n", "\t", " \n\t \n"]

        strings.forEach { string in
            XCTAssertNil(string.displayableString,
                         "\"\(string)\" should not be considered displayable")
        }
    }

    func testDisplayableString() {
        let strings = ["a", "abc", "1", "123", "abc123", " abc123", " \n\t \n 123  \n\t \n"]

        strings.forEach { string in
            guard let displayableString = string.displayableString else {
                return XCTFail("\"\(string)\" should be considered displayable")
            }

            XCTAssertEqual(displayableString, string.trimmingCharacters(in: .whitespacesAndNewlines),
                           "Displayable strings should be non-empty and not contain whitespace or newlines")
        }
    }

}
