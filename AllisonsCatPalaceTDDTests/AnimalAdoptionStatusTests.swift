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

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        guard let db = try? Realm() else {
            return XCTFail("Could not initialize realm database")
        }
        realm = db

        try? realm.write {
            realm.deleteAll()
        }
        
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
        let status = AnimalAdoptionStatus.adoptable
        let managed = status.managedObject

        XCTAssertEqual(status.rawValue, managed.value,
                       "Managed object should store correct raw value")
    }

    func testInitializingFromManagedObject() {
        let status = AnimalAdoptionStatus.onHold
        let managed = status.managedObject
        let objectFromManaged = AnimalAdoptionStatus(managedObject: managed)

        XCTAssertEqual(objectFromManaged?.rawValue, status.rawValue)
    }

    func testSavingManagedObject() {
        let status = AnimalAdoptionStatus.onHold
        let managed = status.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalAdoptionStatusObject.self).last!

        let statusFromFetched = AnimalAdoptionStatus(managedObject: fetchedManagedObject)

        XCTAssertEqual(statusFromFetched?.rawValue, status.rawValue,
                       "Fetched adoption status should map back to original value")
    }
}
