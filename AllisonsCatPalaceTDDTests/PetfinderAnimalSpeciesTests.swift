//
//  PetfinderAnimalSpeciesTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class PetfinderAnimalSpeciesTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
    }

    func testInitializerWithEmptyString() {
        XCTAssertNil(PetfinderAnimalSpecies(petFinderRawValue: ""),
                     "Should not create animal species from empty string")
    }

    func testInitializerWithInvalidStrings() {
        let strings = ["dog", "cat", "DOG", "CAT"]

        strings.forEach { character in
            XCTAssertNil(PetfinderAnimalSpecies(petFinderRawValue: ""),
                         "\(character) should not create animal species")
        }
    }

    func testInitializerWithValidStrings() {
        ["Dog", "Cat", "BarnYard", "Bird", "Horse", "Rabbit", "Reptile", "Small&amp;Furry"].forEach { string in
            XCTAssertNotNil(PetfinderAnimalSpecies(petFinderRawValue: string),
                            "\(string) should create an animal species")
        }
    }

    func testAllCases() {
        switch PetfinderAnimalSpecies.dog {
        case .cat, .dog, .barnYard, .bird, .horse, .rabbit, .reptile, .smallAndFurry:
            break
        }
    }

    func testManagedObject() {
        XCTAssertNil(PetfinderAnimalSpeciesObject().value.value,
                     "PetfinderAnimalSpeciesObject should have no value by default")

        let species = PetfinderAnimalSpecies.cat
        let managed = species.managedObject

        XCTAssertEqual(species.rawValue, managed.value.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let species = PetfinderAnimalSpecies.dog
        let managed = species.managedObject
        let objectFromManaged = PetfinderAnimalSpecies(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, species.rawValue)
    }

    func testSavingManagedObject() {
        let original = PetfinderAnimalSpecies.dog
        let managed = original.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(PetfinderAnimalSpeciesObject.self).last!

        let originalValueFromFetched = PetfinderAnimalSpecies(managedObject: fetchedManagedObject)

        XCTAssertEqual(original.rawValue, originalValueFromFetched?.rawValue)
    }
}

func == (lhs: AnimalSpecies, rhs: PetfinderAnimalSpecies) -> Bool {
    return lhs.description == rhs.description
}

func == (potentialLhs: AnimalSpecies?, potentialRhs: PetfinderAnimalSpecies?) -> Bool {
    guard let lhs = potentialLhs,
        let rhs = potentialRhs
        else {
            return false
    }

    return lhs == rhs
}
