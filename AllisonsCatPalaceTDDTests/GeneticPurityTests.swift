//
//  GeneticPurityTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class GeneticPurityTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
    }

    func testPurityCases() {
        [GeneticPurity.purebred, .mixed].forEach { value in
            switch value {
            case .purebred, .mixed:
                break
            }
        }
    }

    func testInitializerWithinValidStrings() {
        ["YES", "NO", "Yes", "No", "", "Blah"].forEach { invalidString in
            XCTAssertNil(GeneticPurity(petFinderRawValue: invalidString),
                         "Should not create genetic purity from invalid strings")
        }
    }

    func testInitializeWithValidStrings() {
        ["yes", "no"].forEach { validString in
            XCTAssertNotNil(GeneticPurity(petFinderRawValue: validString),
                            "Should create genetic purity from valid strings")
        }
    }

    func testIsPurebredFlag() {
        XCTAssertTrue(GeneticPurity.purebred.isPurebred,
                      "Purebred should be purebred")
        XCTAssertFalse(GeneticPurity.mixed.isPurebred,
                       "Mixed should not be purebred")
    }

    func testManagedObject() {
        XCTAssertNil(GeneticPurityObject().value.value,
                     "GeneticPurityObject should have no value by default")

        let original = GeneticPurity.mixed
        let managed = original.managedObject

        XCTAssertEqual(original.rawValue, managed.value.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let original = GeneticPurity.mixed
        let managed = original.managedObject
        let objectFromManaged = GeneticPurity(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, original.rawValue)
    }

    func testSavingManagedObject() {
        let original = GeneticPurity.mixed
        let managed = original.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(GeneticPurityObject.self).last!

        let originalValueFromFetched = GeneticPurity(managedObject: fetchedManagedObject)

        XCTAssertEqual(original.rawValue, originalValueFromFetched?.rawValue)
    }

}
