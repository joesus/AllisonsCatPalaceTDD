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
        XCTAssertNil(manager.value(forKey: .testKey),
                     "Should return nil when no value for key is found")
    }

    func testReturnsAnyWhenValueForKeyExists() {
        manager.set(value: "a string value", forKey: .stringKey)
        let retrievedValue = manager.value(forKey: .stringKey)

        XCTAssertNotNil(retrievedValue,
                        "Value for existing key should not return nil")
        XCTAssertEqual(retrievedValue as? String, "a string value",
                       "Should be able to set and retrieve an integer value")
    }

    func testStoringIntValue() {
        manager.set(value: 80220, forKey: .intKey)

        XCTAssertEqual(manager.value(forKey: .intKey) as? Int, 80220,
                       "Should be able to set and retrieve an integer value")
    }

    func testClearingSettings() {
        manager.set(value: "notAZipCode", forKey: .zipCode)
        XCTAssertNotNil(UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier!),
                        "Should be a persistent domain for storing user defaults associated with the bundle identifier")
        manager.clear()
        XCTAssertNil(UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier!),
                        "Should not be a persistent domain for storing user defaults after clearing settings")
        XCTAssertNil(manager.value(forKey: .zipCode),
                        "Clearing defaults should remove stored values")
    }
}

extension SettingsManager.Key {
    static let testKey = SettingsManager.Key(rawValue: "testKey")
    static let intKey = SettingsManager.Key(rawValue: "intKey")
    static let stringKey = SettingsManager.Key(rawValue: "stringKey")
}
