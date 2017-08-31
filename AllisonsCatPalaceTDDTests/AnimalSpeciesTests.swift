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
        XCTAssertEqual(AnimalSpecies(petFinderRawValue: ""), .other,
                     "Should create animal species other from empty string")
    }

    func testInitializerWithInvalidStrings() {
        let strings = ["dog", "cat", "DOG", "CAT", "BarnYard", "Bird", "Horse", "Rabbit", "Reptile"]

        strings.forEach { character in
            XCTAssertEqual(AnimalSpecies(petFinderRawValue: ""), .other,
                           "\(character) should create animal species other")
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
            case .cat, .dog, .other:
                break
            }
        }
    }

    func testManagedObject() {
        let species = AnimalSpecies.cat
        let managed = species.managedObject

        XCTAssertEqual(species.rawValue, managed.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let species = AnimalSpecies.dog
        let managed = species.managedObject
        let objectFromManaged = AnimalSpecies(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, species.rawValue)
    }
}
