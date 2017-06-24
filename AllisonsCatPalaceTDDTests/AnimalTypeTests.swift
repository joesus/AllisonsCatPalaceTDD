//
//  AnimalTypeTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalTypeTests: XCTestCase {

    func testInitializerWithEmptyString() {
        XCTAssertNil(AnimalType(petFinderRawValue: ""),
                     "Should not create animal type from empty string")
    }

    func testInitializerWithInvalidStrings() {
        let strings = ["dog", "cat", "DOG", "CAT", "BarnYard", "Bird", "Horse", "Rabbit", "Reptile"]

        strings.forEach { character in
            XCTAssertNil(AnimalType(petFinderRawValue: character),
                         "\(character) should not create an animal type")
        }
    }

    func testInitializerWithValidStrings() {
        let strings = ["Dog", "Cat"]

        strings.forEach { string in
            XCTAssertNotNil(AnimalType(petFinderRawValue: string),
                            "\(string) should create an animal type")
        }
    }

    func testAllCases() {
        let animalTypes = [AnimalType.cat, .dog]

        animalTypes.forEach { type in
            switch type {
            case .cat, .dog:
                break
            }
        }
    }

}
