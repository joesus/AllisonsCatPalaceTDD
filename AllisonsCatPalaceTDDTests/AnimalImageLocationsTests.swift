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

        realm = realmForTest(withName: name!)
        resetRealm(realm)
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

    func testManagedObject() {
        XCTAssertEqual(AnimalImageLocationsObject().small, Data(),
                       "Animal image locations for small images should have empty data object as default")
        XCTAssertEqual(AnimalImageLocationsObject().medium, Data(),
                       "Animal image locations for medium images should have empty data object as default")
        XCTAssertEqual(AnimalImageLocationsObject().large, Data(),
                       "Animal image locations for large images should have empty data object as default")
    }

    func testManagedObjectWithEmptyLocations() {
        let originalLocations = SampleImageLocations.noImages
        let managedLocations = originalLocations.managedObject

        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, originalLocations.small)
        XCTAssertEqual(decodedLocations.medium, originalLocations.medium)
        XCTAssertEqual(decodedLocations.large, originalLocations.large)
    }

    func testRealmObjectWithSingleNonEmptyLocations() {
        let managedLocations = SampleImageLocations.smallMediumLarge.managedObject

        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, SampleImageLocations.smallMediumLarge.small)
        XCTAssertEqual(decodedLocations.medium, SampleImageLocations.smallMediumLarge.medium)
        XCTAssertEqual(decodedLocations.large, SampleImageLocations.smallMediumLarge.large)
    }

    func testRealmObjectWithMultipleNonEmptyLocations() {
        let locations = SampleImageLocations.multipleSmall

        let managedLocations = locations.managedObject
        let decodedLocations = AnimalImageLocations(managedObject: managedLocations)

        XCTAssertEqual(decodedLocations.small, locations.small)
        XCTAssertEqual(decodedLocations.medium, locations.medium)
        XCTAssertEqual(decodedLocations.large, locations.large)
    }

    func testSavingManagedObject() {
        let locations = SampleImageLocations.multipleSmall

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
