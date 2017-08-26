//
//  SettingsManagerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class SettingsManagerTests: XCTestCase {

    let manager = SettingsManager.shared

    func testReturnsNilWhenNoValueForKey() {
        XCTAssertNil(manager.value(forKey: "blahblah"),
                     "Should return nil when no value for key is found")
    }

    func testReturnsAnyWhenValueForKeyExists() {
        let key = "stringValue"
        manager.set(value: "a string value", forKey: key)
        let retrievedValue = manager.value(forKey: key)

        XCTAssertNotNil(retrievedValue,
                        "Value for existing key should not return nil")
        XCTAssertEqual(retrievedValue as? String, "a string value",
                       "Should be able to set and retrieve an integer value")
    }

    func testStoringIntValue() {
        manager.set(value: 80220, forKey: "Int")

        XCTAssertEqual(manager.value(forKey: "Int") as? Int, 80220,
                       "Should be able to set and retrieve an integer value")
    }
}
