//
//  AnimalSpeciesTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class AnimalSpeciesTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
    }

    func testInitializerWithEmptyString() {
        XCTAssertNil(AnimalSpecies(petFinderRawValue: ""),
                     "Should not create animal species from empty string")
    }

    func testInitializerWithInvalidStrings() {
        let strings = ["dog", "cat", "DOG", "CAT"]

        strings.forEach { character in
            XCTAssertNil(AnimalSpecies(petFinderRawValue: ""),
                         "\(character) should not create animal species")
        }
    }

    func testInitializerWithValidStrings() {
        ["Dog", "Cat", "BarnYard", "Bird", "Horse", "Rabbit", "Reptile", "Small&amp;Furry"].forEach { string in
            XCTAssertNotNil(AnimalSpecies(petFinderRawValue: string),
                            "\(string) should create an animal species")
        }
    }

    func testAllCases() {
        switch AnimalSpecies.dog {
        case .cat, .dog, .barnYard, .bird, .horse, .rabbit, .reptile, .smallAndFurry:
            break
        }
    }

    func testManagedObject() {
        XCTAssertNil(AnimalSpeciesObject().value,
                     "AnimalSpeciesObject should have no value by default")

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

    func testSavingManagedObject() {
        let original = AnimalSpecies.dog
        let managed = original.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalSpeciesObject.self).last!

        let originalValueFromFetched = AnimalSpecies(managedObject: fetchedManagedObject)

        XCTAssertEqual(original.rawValue, originalValueFromFetched?.rawValue)
    }
}
