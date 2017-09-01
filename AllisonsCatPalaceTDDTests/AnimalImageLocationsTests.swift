//
//  AnimalImageLocationsTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AllisonsCatPalaceTDD

class AnimalImageLocationsTests: XCTestCase {
    var realm: Realm!

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        guard let db = try? Realm() else {
            return XCTFail("Could not initialize realm database")
        }
        realm = db

        try! realm.write {
            realm.deleteAll()
        }

    }

    func testHasNoImageLocationsByDefault() {
        let locations = AnimalImageLocations()
        XCTAssertTrue(locations.small.isEmpty,
                      "Animal image locations should have no small images by default")
        XCTAssertTrue(locations.medium.isEmpty,
                      "Animal image locations should have no medium images by default")
        XCTAssertTrue(locations.large.isEmpty,
                      "Animal image locations should have no large images by default")
    }

    func testCreatingWithImageLocations() {
        let small = [URL(string: "https://www.google.com/")!,
                     URL(string: "https://www.google.com/./")!]
        let medium = [URL(string: "https://www.google.com/")!,
                      URL(string: "https://www.google.com/./")!]
        let large = [URL(string: "https://www.google.com/")!,
                     URL(string: "https://www.google.com/./")!,
                     URL(string: "https://www.apple.com")!]

        let locations = AnimalImageLocations(
            small: small,
            medium: medium,
            large: large
        )

        XCTAssertEqual(locations.small, [small[0]],
                       "Duplicate urls should be removed")
        XCTAssertEqual(locations.medium, [medium[0]],
                       "Medium locations should be created with provided location")
        XCTAssertEqual(locations.large, [large[0], large[2]],
                       "Multiple locations should be created if they are not duplicates")
    }

    func testRealmObjectWithEmptyLocations() {
        let originalLocations = AnimalImageLocations(small: [],
                                                    medium: [],
                                                    large: [])
        let managedLocations = originalLocations.managedObject

        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, originalLocations.small)
        XCTAssertEqual(decodedLocations.medium, originalLocations.medium)
        XCTAssertEqual(decodedLocations.large, originalLocations.large)
    }

    func testRealmObjectWithSingleNonEmptyLocations() {
        let managedLocations = sampleImageLocations.managedObject

        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, sampleImageLocations.small)
        XCTAssertEqual(decodedLocations.medium, sampleImageLocations.medium)
        XCTAssertEqual(decodedLocations.large, sampleImageLocations.large)
    }

    func testRealmObjectWithMultipleNonEmptyLocations() {
        let locations = AnimalImageLocations(small: [URL(string: "https://www.google.com/test.png")!,
                                                     URL(string: "https://www.google.com/test.png")!],
                                             medium: [],
                                             large: [])

        let managedLocations = locations.managedObject
        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, locations.small)
        XCTAssertEqual(decodedLocations.medium, locations.medium)
        XCTAssertEqual(decodedLocations.large, locations.large)
    }

    func testSavingManagedObject() {
        let locations = AnimalImageLocations(small: [URL(string: "https://www.google.com/test.png")!,
                                                     URL(string: "https://www.google.com/test2.png")!],
                                             medium: [],
                                             large: [])

        let managedLocations = locations.managedObject

        try? realm.write {
            realm.add(managedLocations)
        }

        let locationDataFromRealm = realm.objects(AnimalImageLocationsObject.self).last

        let decodedLocations = AnimalImageLocations(managedObject: locationDataFromRealm!)

        XCTAssertEqual(decodedLocations.small, locations.small)
        XCTAssertEqual(decodedLocations.medium, locations.medium)
        XCTAssertEqual(decodedLocations.large, locations.large)
    }
}
