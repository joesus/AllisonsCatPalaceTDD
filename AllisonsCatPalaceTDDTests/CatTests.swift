//
//  CatTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatTests: XCTestCase {

    let cat = Cat(name: "CatOne", identifier: 1)
    let catWithURL = Cat(name: "CatURL", identifier: 1, imageUrl: URL(string: "https://example.com/foo.gif"))

    func testCreateCat() {
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

    func testCutenessLevel() {
        XCTAssertNil(cat.cutenessLevel, "Cutenesslevel property is nil by default")
        cat.cutenessLevel = 10
        XCTAssertEqual(cat.cutenessLevel, 10, "Should allow setting of cuteness level")
        cat.cutenessLevel = nil
        XCTAssertNil(cat.cutenessLevel, "Should allow for clearing cuteness level")
    }

    func testCutenessValueMustBeInRange() {
        cat.cutenessLevel = 0
        XCTAssertNil(cat.cutenessLevel, "Should not allow cuteness levels out of range")
        cat.cutenessLevel = 12
        XCTAssertNil(cat.cutenessLevel, "Should not allow cuteness levels out of range")
        (1...11).forEach { level in
            cat.cutenessLevel = level
            XCTAssertEqual(cat.cutenessLevel, level, "Should allow valid cuteness levels")
        }
    }

    func testFavorites() {
        let favorite = Favorite(identifier: 1, category: "Hat", value: "Cowboy")!
        let anotherFavorite = Favorite(identifier: 2, category: "Toy", value: "String")!

        XCTAssertTrue(cat.favorites.isEmpty, "Favorites should be an empty array of favorites by default")

        cat.favorites = [favorite, anotherFavorite]
        XCTAssertEqual(cat.favorites.count, 2, "Should allow setting favorites")
    }

    func testGenotype() {
        XCTAssertNil(cat.genotype, "Should not have a genotype by default")
        cat.genotype = sampleGenotype
        XCTAssertNotNil(cat.genotype, "Should allow setting genotype")
    }

    func testSex() {
        XCTAssertEqual(cat.sex, .unknown, "Sex should be unknown by default")
        cat.sex = .male
        XCTAssertEqual(cat.sex, .male, "Sex should be settable")
    }

    func testGreeting() {
        XCTAssertNil(cat.greeting, "City property is nil by default")
        cat.greeting = "Hello"
        XCTAssertEqual(cat.greeting, "Hello", "Should not mutate data during setting")
    }

    func testGreetingShouldNotBeEmptyString() {
        cat.greeting = ""
        XCTAssertNil(cat.greeting, "Should not set greeting to empty string")
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
}
