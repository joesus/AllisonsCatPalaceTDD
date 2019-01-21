//
//  AnimalSexTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class AnimalSexTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: self.name)
        resetRealm(realm)
    }

    func testCannotCreateAnimalSexFromEmptyString() {
        XCTAssertEqual(AnimalSex(petFinderRawValue: ""), .unknown,
                       "Empty string should default to unknown value")
    }

    func testAnimalSexInitializerWithSingleCharacter() {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        let validCharacters = ["M", "F"]
        characters.forEach { character in
            if validCharacters.contains(String(character)) {
                XCTAssertNotNil(AnimalSex(petFinderRawValue: String(character)),
                                "\(character) should create an animal sex")
            } else {
                XCTAssertEqual(AnimalSex(petFinderRawValue: String(character)), .unknown,
                               "\(character) should default to unknown")
            }
        }
    }

    func testAnimalSexInitializerWithInvalidStrings() {
        let strings = ["male", "female"]

        strings.forEach { character in
            XCTAssertEqual(AnimalSex(petFinderRawValue: String(character)), .unknown,
                           "\(character) should default to unknown")
        }
    }

    func testAllCases() {
        let animalSexes = [AnimalSex.male, .female, .unknown]

        animalSexes.forEach { sex in
            switch sex {
            case .male, .female, .unknown:
                break
            }
        }
    }

    func testManagedObject() {
        XCTAssertNil(AnimalSexObject().value,
                     "AnimalSexObject should have no value by default")

        let sex = AnimalSex.male
        let managed = sex.managedObject

        XCTAssertEqual(sex.rawValue, managed.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let sex = AnimalSex.male
        let managed = sex.managedObject
        let objectFromManaged = AnimalSex(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, sex.rawValue)
    }

    func testSavingManagedObject() {
        let sex = AnimalSex.male
        let managed = sex.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalSexObject.self).last!

        let originalValueFromFetched = AnimalSex(managedObject: fetchedManagedObject)

        XCTAssertEqual(sex.rawValue, originalValueFromFetched?.rawValue)
    }

}
