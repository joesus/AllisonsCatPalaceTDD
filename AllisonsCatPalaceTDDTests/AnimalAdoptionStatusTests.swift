//
//  AnimalAdoptionStatusTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest
import RealmSwift

class AnimalAdoptionStatusTests: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
    }

    func testAllCases() {
        let statuses = [
            AnimalAdoptionStatus.adoptable,
            .onHold,
            .pending
        ]

        statuses.forEach { status in
            switch status {
            case .adoptable, .onHold, .pending:
                break
            }
        }
    }

    func testCreatingWithEmptyString() {
        XCTAssertNil(AnimalAdoptionStatus(petFinderRawValue: ""),
                     "Should not create an adoption status from an empty string")
    }

    func testCreatingWithBadStrings() {
        ["X", "a", "h", "p", "\n"].forEach { badString in
            XCTAssertNil(AnimalAdoptionStatus(petFinderRawValue: badString),
                         "Should not create an adoption status from a bad string")
        }
    }

    func testCreatingWithGoodStrings() {
        ["A", "H", "P"].forEach { goodString in
            XCTAssertNotNil(AnimalAdoptionStatus(petFinderRawValue: goodString),
                         "Should create an adoption status from a good string")
        }
    }

    func testStatusAdoptability() {
        XCTAssertTrue(AnimalAdoptionStatus.adoptable.isAdoptable,
                      "Adoptable status should be considered adoptable")
        XCTAssertFalse(AnimalAdoptionStatus.onHold.isAdoptable,
                       "On hold status should not be considered adoptable")
        XCTAssertFalse(AnimalAdoptionStatus.pending.isAdoptable,
                      "Pending status should not be considered adoptable")
    }

    func testManagedObject() {
        XCTAssertNil(AnimalAdoptionStatusObject().value.value,
                     "AnimalAdoptionStatusObject should have no value by default")

        XCTAssertEqual(AnimalAdoptionStatus.adoptable.rawValue,
                       AnimalAdoptionStatus.adoptable.managedObject.value.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        XCTAssertEqual(AnimalAdoptionStatus(managedObject: AnimalAdoptionStatus.onHold.managedObject)?.rawValue,
                       AnimalAdoptionStatus.onHold.rawValue,
                       "Adoption status initialized from managed object should have correct value")
    }

    func testSavingManagedObject() {
        try? realm.write {
            realm.add(AnimalAdoptionStatus.onHold.managedObject)
        }

        let fetchedManagedObject = realm.objects(AnimalAdoptionStatusObject.self).last!

        XCTAssertEqual(AnimalAdoptionStatus(managedObject: fetchedManagedObject)?.rawValue,
                       AnimalAdoptionStatus.onHold.rawValue,
                       "Fetched adoption status should map back to original value")
    }
}
