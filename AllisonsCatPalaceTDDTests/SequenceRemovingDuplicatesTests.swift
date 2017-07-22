//
//  SequenceRemovingDuplicatesTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  expectedright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class SequenceRemovingDuplicatesTests: XCTestCase {
    
    func testIntegerArrayWithoutDuplicates() {
        let original = [1, 2, 3, 4, 5]

        XCTAssertEqual(original.removingDuplicates(), original,
                       "Should not remove unique values")
    }

    func testStringArrayWithoutDuplicates() {
        let original = ["one", "two", "three", "four"]

        XCTAssertEqual(original.removingDuplicates(), original,
                       "Should not remove unique values")
    }

    func testURLArrayWithoutDuplicates() {
        let original = [URL(string: "https://www.google.com")!,
                        URL(string: "https://www.apple.com")!]

        XCTAssertEqual(original.removingDuplicates(), original,
                       "Should not remove unique values")
    }

    func testIntegerArrayWithDuplicates() {
        let original = [1, 2, 3, 1, 2]
        let expected = [1, 2, 3]

        XCTAssertEqual(original.removingDuplicates(), expected,
                       "Should remove duplicate values")
    }

    func testStringArrayWithDuplicates() {
        let original = ["one", "two", "three", "one"]
        let expected = ["one", "two", "three"]

        XCTAssertEqual(original.removingDuplicates(), expected,
                       "Should remove duplicate values")
    }

    func testURLArrayWithDuplicates() {
        let original = [URL(string: "https://www.google.com")!,
                        URL(string: "https://www.google.com")!,
                        URL(string: "https://www.apple.com/stuff/things")!,
                        URL(string: "https://www.apple.com/stuff/../stuff/things")!
                        ]
        let expected = [URL(string: "https://www.google.com")!,
                        URL(string: "https://www.apple.com/stuff/things")!]

        XCTAssertEqual(original.removingDuplicates(), expected,
                       "Should remove duplicate values")
    }
}
