// swiftlint:disable function_body_length type_body_length
//
//  AnimalTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import RealmSwift
import XCTest

class AnimalTests: XCTestCase {

    var realm: Realm!
    let cat = Animal(name: "CatOne", identifier: 1)
    let catWithURL = Animal(name: "CatURL", identifier: 1, imageUrl: URL(string: "https://example.com/foo.gif"))

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
    }

    func testCreateAnimal() {
        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testAbout() {
        XCTAssertNil(cat.about, "About property is nil by default")
        cat.about = "Nice cat"
        XCTAssertEqual(cat.about, "Nice cat", "Should not mutate data during setting")
    }

    func testAboutCannotBeEmptyString() {
        cat.about = ""
        XCTAssertNil(cat.about, "Should not set about to empty string")
    }

    func testAdoptionStatus() {
        XCTAssertNil(cat.adoptionStatus, "Should not have adoption status by default")
        cat.adoptionStatus = .onHold
        XCTAssertEqual(cat.adoptionStatus, .onHold,
                       "Should allow setting of adoption status")
    }

    func testAdoptableIsBasedOnAdoptionStatus() {
        XCTAssertFalse(cat.isAdoptable, "Adoptable should be false when adoption status is unknown")
        cat.adoptionStatus = .adoptable
        XCTAssertTrue(cat.isAdoptable, "Should be adoptable when adoption status is adoptable")
        cat.adoptionStatus = .onHold
        XCTAssertFalse(cat.isAdoptable, "Adoptable should be false when adoption status is on hold")
        cat.adoptionStatus = .pending
        XCTAssertFalse(cat.isAdoptable, "Adoptable should be false when adoption status is on pending")
    }

    func testAge() {
        XCTAssertNil(cat.age, "Age property is nil by default")
        cat.age = .adult
        XCTAssertEqual(cat.age, .adult, "Should allow setting of age")
    }

    func testCity() {
        XCTAssertNil(cat.city, "City property is nil by default")
        cat.city = "Milwaukee"
        XCTAssertEqual(cat.city, "Milwaukee", "Should not mutate data during setting")
    }

    func testCityCannotBeEmptyString() {
        cat.city = ""
        XCTAssertNil(cat.city, "Should not set city to empty string")
    }

    func testGenotype() {
        XCTAssertNil(cat.genotype, "Should not have a genotype by default")
        cat.genotype = SampleGenotypes.mixedCatMultipleBreeds
        XCTAssertNotNil(cat.genotype, "Should allow setting genotype")
    }

    func testSex() {
        XCTAssertEqual(cat.sex, .unknown, "Sex should be unknown by default")
        cat.sex = .male
        XCTAssertEqual(cat.sex, .male, "Sex should be settable")
    }

    func testStateCode() {
        XCTAssertNil(cat.stateCode, "StateCode property is nil by default")
        cat.stateCode = "CO"
        XCTAssertEqual(cat.stateCode, "CO", "Should not mutate data during setting")
    }

    func testStateShouldNotBeEmptyString() {
        cat.stateCode = ""
        XCTAssertNil(cat.stateCode, "Should not set stateCode to empty string")
    }

    func testStateCodeMustBeTwoAlphabeticalCharacters() {
        cat.stateCode = "X"
        XCTAssertNil(cat.stateCode, "State code must be two characters")

        cat.stateCode = "xyZ"
        XCTAssertNil(cat.stateCode, "State code must be two characters")

        cat.stateCode = "12"
        XCTAssertNil(cat.stateCode, "State code must be alphabetical")
    }

    func testStateCodeIsConvertedToUppercase() {
        cat.stateCode = "co"
        XCTAssertEqual(cat.stateCode, "CO", "State code setter should capitalize state code")
    }

    func testSize() {
        XCTAssertNil(cat.size, "Size should be nil by default")
        cat.size = .medium
        XCTAssertEqual(cat.size, .medium, "Should not mutate size during setting")
    }

    func testImageLocationsEmptyByDefault() {
        XCTAssertEqual(cat.imageLocations.small, [],
                       "Cat should not have any small images by default")
        XCTAssertEqual(cat.imageLocations.medium, [],
                       "Cat should not have any medium images by default")
        XCTAssertEqual(cat.imageLocations.large, [],
                       "Cat should not have any large images by default")
    }

    func testImageLocations() {
        let sampleURLs = [URL(string: "https://www.google.com")!]
        let imageLocations = AnimalImageLocations(
            small: sampleURLs,
            medium: sampleURLs,
            large: sampleURLs
        )

        cat.imageLocations = imageLocations

        XCTAssertEqual(cat.imageLocations.small, sampleURLs,
                       "Cat should have image locations")
        XCTAssertEqual(cat.imageLocations.medium, sampleURLs,
                       "Cat should have image locations")
        XCTAssertEqual(cat.imageLocations.large, sampleURLs,
                       "Cat should have image locations")
    }

    func testDefaultManagedObject() {
        let object = AnimalObject()
        XCTAssertNil(object.name,
                     "AnimalObject should have no name by default")
        XCTAssertNil(object.identifier.value,
                     "AnimalObject should have no identifier by default")
        XCTAssertNil(object.about,
                     "AnimalObject should have no about by default")
        XCTAssertNil(object.adoptionStatus,
                     "AnimalObject should have no adoptionStatus by default")
        XCTAssertNil(object.age,
                     "AnimalObject should have no age by default")
        XCTAssertNil(object.city,
                     "AnimalObject should have no city by default")
        XCTAssertNil(object.sex?.value,
                     "AnimalObject should have no sex by default")
        XCTAssertNil(object.genotype,
                     "AnimalObject should have no genotype by default")
        XCTAssertNil(object.stateCode,
                     "AnimalObject should have no stateCode by default")
        XCTAssertNil(object.size,
                     "AnimalObject should have no size by default")
        XCTAssertNil(object.imageLocations,
                     "AnimalObject should have no image locations by default")
    }

    func testManagedObject() {
        let animal = cats[1]
        animal.about = "Test string"
        animal.adoptionStatus = .onHold
        animal.age = .young
        animal.city = "NYC"
        animal.sex = .male
        animal.genotype = SampleGenotypes.mixedCatMultipleBreeds
        animal.stateCode = "NY"
        animal.size = .medium
        animal.imageLocations = SampleImageLocations.smallMediumLarge

        let breedsData = NSKeyedArchiver.archivedData(withRootObject: animal.genotype!.breeds)
        let imageLocationSmallData = NSKeyedArchiver.archivedData(withRootObject: animal.imageLocations.small)
        let imageLocationMediumData = NSKeyedArchiver.archivedData(withRootObject: animal.imageLocations.medium)
        let imageLocationLargeData = NSKeyedArchiver.archivedData(withRootObject: animal.imageLocations.large)

        XCTAssertEqual(animal.about, animal.managedObject.about,
                       "Managed object for animal should store correct value for about")
        XCTAssertEqual(animal.about, animal.managedObject.about,
                       "Managed object for animal should store correct value for about")
        XCTAssertEqual(animal.adoptionStatus?.rawValue, animal.managedObject.adoptionStatus?.value.value,
                       "Managed object for animal should store correct value for adoptionStatus")
        XCTAssertEqual(animal.age?.rawValue, animal.managedObject.age?.value,
                       "Managed object for animal should store correct value for age")
        XCTAssertEqual(animal.city, animal.managedObject.city,
                       "Managed object for animal should store correct value for city")
        XCTAssertEqual(animal.sex.rawValue, animal.managedObject.sex?.value,
                       "Managed object for animal should store correct value for sex")
        XCTAssertEqual(animal.genotype?.species.rawValue, animal.managedObject.genotype?.species?.value,
                       "Managed object for animal should store correct value for genotype - species")
        XCTAssertEqual(animal.genotype?.purity.rawValue, animal.managedObject.genotype?.purity?.value.value,
                       "Managed object for animal should store correct value for genotype - purity")
        XCTAssertEqual(breedsData, animal.managedObject.genotype?.breeds,
                       "Managed object for animal should store correct value for genotype - breeds")
        XCTAssertEqual(animal.stateCode, animal.managedObject.stateCode,
                       "Managed object for animal should store correct value for stateCode")
        XCTAssertEqual(animal.size?.rawValue, animal.managedObject.size?.value,
                       "Managed object for animal should store correct value for size")
        XCTAssertEqual(imageLocationSmallData, animal.managedObject.imageLocations?.small,
                       "Managed object for animal should store correct image locations - small")
        XCTAssertEqual(imageLocationMediumData, animal.managedObject.imageLocations?.medium,
                       "Managed object for animal should store correct image locations - medium")
        XCTAssertEqual(imageLocationLargeData, animal.managedObject.imageLocations?.large,
                       "Managed object for animal should store correct image locations - large")
    }

    func testInitializingFromManagedObject() {
        let animal = cats[1]
        animal.about = "Test string"
        animal.adoptionStatus = .onHold
        animal.age = .young
        animal.city = "NYC"
        animal.sex = .male
        animal.genotype = SampleGenotypes.mixedCatMultipleBreeds
        animal.stateCode = "NY"
        animal.size = .medium
        animal.imageLocations = SampleImageLocations.smallMediumLarge

        let objectFromManaged = Animal(managedObject: animal.managedObject)

        XCTAssertEqual(animal.name, objectFromManaged?.name,
                       "Managed object from animal should have correct name")
        XCTAssertEqual(animal.adoptionStatus, objectFromManaged?.adoptionStatus,
                       "Managed object from animal should have correct adoption status")
        XCTAssertEqual(animal.age, objectFromManaged?.age,
                       "Managed object from animal should have correct age")
        XCTAssertEqual(animal.city, objectFromManaged?.city,
                       "Managed object from animal should have correct city")
        XCTAssertEqual(animal.sex, objectFromManaged?.sex,
                       "Managed object from animal should have correct sex")
        XCTAssertEqual(animal.genotype?.species, objectFromManaged?.genotype?.species,
                       "Managed object from animal should have correct genotype - species")
        XCTAssertEqual(animal.genotype?.purity, objectFromManaged?.genotype?.purity,
                       "Managed object from animal should have correct genotype - purity")
        XCTAssertEqual((animal.genotype?.breeds)!, (objectFromManaged?.genotype?.breeds)!,
                       "Managed object from animal should have correct genotype - breeds")
        XCTAssertEqual(animal.stateCode, objectFromManaged?.stateCode,
                       "Managed object from animal should have correct state code")
        XCTAssertEqual(animal.size, objectFromManaged?.size,
                       "Managed object from animal should have correct size")
        XCTAssertEqual(animal.imageLocations.small, objectFromManaged!.imageLocations.small,
                       "Managed object from animal should have correct image locations - small")
        XCTAssertEqual(animal.imageLocations.medium, objectFromManaged!.imageLocations.medium,
                       "Managed object from animal should have correct image locations - medium")
        XCTAssertEqual(animal.imageLocations.large, objectFromManaged!.imageLocations.large,
                       "Managed object from animal should have correct image locations - large")
    }

    func testSavingManagedObject() {
        let animal = cats[1]
        animal.about = "Test string"
        animal.adoptionStatus = .onHold
        animal.age = .young
        animal.city = "NYC"
        animal.sex = .male
        animal.genotype = SampleGenotypes.mixedCatMultipleBreeds
        animal.stateCode = "NY"
        animal.size = .medium
        animal.imageLocations = SampleImageLocations.smallMediumLarge

        let managed = animal.managedObject

        try? realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalObject.self).last!

        let originalValueFromFetched = Animal(managedObject: fetchedManagedObject)

        XCTAssertEqual(animal.name, originalValueFromFetched?.name,
                       "Managed object from animal should have correct name")
        XCTAssertEqual(animal.adoptionStatus, originalValueFromFetched?.adoptionStatus,
                       "Managed object from animal should have correct adoption status")
        XCTAssertEqual(animal.age, originalValueFromFetched?.age,
                       "Managed object from animal should have correct age")
        XCTAssertEqual(animal.city, originalValueFromFetched?.city,
                       "Managed object from animal should have correct city")
        XCTAssertEqual(animal.sex, originalValueFromFetched?.sex,
                       "Managed object from animal should have correct sex")
        XCTAssertEqual(animal.genotype?.species, originalValueFromFetched?.genotype?.species,
                       "Managed object from animal should have correct genotype - species")
        XCTAssertEqual(animal.genotype?.purity, originalValueFromFetched?.genotype?.purity,
                       "Managed object from animal should have correct genotype - purity")
        XCTAssertEqual((animal.genotype?.breeds)!, (originalValueFromFetched?.genotype?.breeds)!,
                       "Managed object from animal should have correct genotype - breeds")
        XCTAssertEqual(animal.stateCode, originalValueFromFetched?.stateCode,
                       "Managed object from animal should have correct state code")
        XCTAssertEqual(animal.size, originalValueFromFetched?.size,
                       "Managed object from animal should have correct size")
        XCTAssertEqual(animal.imageLocations.small, originalValueFromFetched!.imageLocations.small,
                       "Managed object from animal should have correct image locations - small")
        XCTAssertEqual(animal.imageLocations.medium, originalValueFromFetched!.imageLocations.medium,
                       "Managed object from animal should have correct image locations - medium")
        XCTAssertEqual(animal.imageLocations.large, originalValueFromFetched!.imageLocations.large,
                       "Managed object from animal should have correct image locations - large")
    }

    func testDoesNotSaveDuplicates() {
        let animal = cats[1]
        animal.about = "Test string"
        animal.adoptionStatus = .onHold
        animal.age = .young
        animal.city = "NYC"
        animal.sex = .male
        animal.genotype = SampleGenotypes.mixedCatMultipleBreeds
        animal.stateCode = "NY"
        animal.size = .medium

        let managed = animal.managedObject
        let duplicate = animal.managedObject

        try? realm.write {
            realm.add(managed, update: true)
            realm.add(duplicate, update: true)
        }

        let animals: [Animal] = realm.objects(AnimalObject.self).flatMap {
            Animal(managedObject: $0)
        }

        XCTAssertEqual(animals.count, 1,
                       "Should not save duplicates to realm")
    }
}
