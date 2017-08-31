//
//  AnimalAgeGroupTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalAgeGroupTests: XCTestCase {

    func testAllCases() {
        let groups = [AnimalAgeGroup.baby, .young, .adult, .senior]

        groups.forEach { size in
            switch size {
            case .baby, .young, .adult, .senior:
                break
            }
        }
    }

    func testInitializingWithEmptyString() {
        XCTAssertNil(AnimalAgeGroup(petFinderRawValue: ""),
                     "Should not create age group from empty string")
    }

    func testCannotInitializeWithInvalidStrings() {
        let invalidStrings = ["baby", "young", "adult", "senior", "BABY", "YOUNG", "ADULT", "SENIOR"]

        invalidStrings.forEach { string in
            XCTAssertNil(AnimalAgeGroup(petFinderRawValue: string),
                         "Should not create age group from: \(string)")
        }
    }

    func testInitializingWithValidStrings() {
        let validStrings = ["Baby", "Young", "Adult", "Senior"]

        validStrings.forEach { string in
            XCTAssertNotNil(AnimalAgeGroup(petFinderRawValue: string),
                            "Should create age group from: \(string)")
        }
    }

    func testManagedObject() {
        let ageGroup = AnimalAgeGroup.adult
        let managed = ageGroup.managedObject

        XCTAssertEqual(ageGroup.rawValue, managed.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let ageGroup = AnimalAgeGroup.baby
        let managed = ageGroup.managedObject
        let objectFromManaged = AnimalAgeGroup(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, ageGroup.rawValue)
    }

}
