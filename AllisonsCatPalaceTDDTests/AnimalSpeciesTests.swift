//
//  AnimalSpeciesTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AllisonsCatPalaceTDD

class AnimalSpeciesTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        reset(realm)
    }

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
        XCTAssertNil(AnimalSpeciesObject().value.value,
                     "AnimalSpeciesObject should have no value by default")

        let species = AnimalSpecies.cat
        let managed = species.managedObject

        XCTAssertEqual(species.rawValue, managed.value.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let species = AnimalSpecies.dog
        let managed = species.managedObject
        let objectFromManaged = AnimalSpecies(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, species.rawValue)
    }

    func testSavingManagedObject() {
        let original = AnimalSpecies.dog
        let managed = original.managedObject

        try! realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalSpeciesObject.self).last!

        let originalValueFromFetched = AnimalSpecies(managedObject: fetchedManagedObject)

        XCTAssertEqual(original.rawValue, originalValueFromFetched?.rawValue)
    }
}
