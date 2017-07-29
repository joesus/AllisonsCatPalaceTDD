//
//  AnimalSpeciesTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalSpeciesTests: XCTestCase {

    func testInitializerWithEmptyString() {
        XCTAssertNil(AnimalSpecies(petFinderRawValue: ""),
                     "Should not create animal species from empty string")
    }

    func testInitializerWithInvalidStrings() {
        let strings = ["dog", "cat", "DOG", "CAT", "BarnYard", "Bird", "Horse", "Rabbit", "Reptile"]

        strings.forEach { character in
            XCTAssertNil(AnimalSpecies(petFinderRawValue: character),
                         "\(character) should not create an animal species")
        }
    }

    func testInitializerWithValidStrings() {
        ["Dog", "Cat"].forEach { string in
            XCTAssertNotNil(AnimalSpecies(petFinderRawValue: string),
                            "\(string) should create an animal species")
        }
    }

    func testAllCases() {
        let animalSpecies = [AnimalSpecies.cat, .dog]

        animalSpecies.forEach { species in
            switch species {
            case .cat, .dog:
                break
            }
        }
    }

}
