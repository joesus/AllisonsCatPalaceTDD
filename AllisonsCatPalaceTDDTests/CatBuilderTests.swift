//
//  CatBuilderTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatBuilderTests: XCTestCase {

    // MARK:- List tests

    // Bad Data
    func testTransformingBadDataToArrayOfCats() {
        let badData = Data(bytes: [0x1])
        let cats = CatBuilder.buildCats(from: badData)
        XCTAssertTrue(cats.isEmpty, "bad data should produce empty list of cats")
    }

    // Empty Data
    func testTransformingEmptyDataToCatList() {
        let emptyData = try! JSONSerialization.data(withJSONObject: [], options: [])
        let cats = CatBuilder.buildCats(from: emptyData)
        XCTAssertTrue(cats.isEmpty, "Empty data should produce empty list of cats")
    }

    // Minimal Data
    func testBuildingCatsFromMinimalCatData() {
        let catData = try! JSONSerialization.data(withJSONObject: [ExternalCatData.valid, ExternalCatData.anotherValid], options: [])
        let cats = CatBuilder.buildCats(from: catData)
        let catOne = cats.first!
        XCTAssertEqual(catOne.name, "CatOne", "First cat name was set incorrectly")
        XCTAssertEqual(catOne.identifier, 1, "First cat Id was set incorrectly")
        let catTwo = cats.last!
        XCTAssertEqual(catTwo.name, "CatTwo", "Second cat name was set incorrectly")
        XCTAssertEqual(catTwo.identifier, 2, "Second cat Id was set incorrectly")
    }

    // MARK:- Single tests

    // Bad Data
    func testTransformingBadDataToCat() {
        let badData = Data(bytes: [0x1])
        let cat = CatBuilder.buildCat(from: badData)
        XCTAssertNil(cat, "Should not create cat with bad data")
    }

    // Missing Data
    func testTransformingEmptyDataToCat() {
        let emptyData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        let cat = CatBuilder.buildCat(from: emptyData)
        XCTAssertNil(cat, "Should not create cat with empty data")
    }

    // Partial Data (with Id)
    func testBuildingCatWithMissingName() {
        let catData = try! JSONSerialization.data(withJSONObject: ExternalCatData.missingName, options: [])
        let cat = CatBuilder.buildCat(from: catData)
        XCTAssertNil(cat, "Should not create cat if name is missing")
    }

    // Partial Data (with name)
    func testBuildingCatWithMissingIdentifier() {
        let catData = try! JSONSerialization.data(withJSONObject: ExternalCatData.missingIdentifier, options: [])
        let cat = CatBuilder.buildCat(from: catData)
        XCTAssertNil(cat, "Should not create cat if identifier is missing")
    }

    // Minimal Data
    func testBuildingCatWithMinimalData() {
        let catData = try! JSONSerialization.data(withJSONObject: ExternalCatData.valid, options: [])
        let cat = CatBuilder.buildCat(from: catData)!
        XCTAssertEqual(cat.name, "CatOne", "Builder should set name correctly from valid data")
        XCTAssertEqual(cat.identifier, 1, "Builder should set identifier correctly from valid data")
    }

    // Full Data
    func testBuildingCatWithFullData() {
        let catData = try! JSONSerialization.data(withJSONObject: ExternalCatData.full, options: [])
        let cat = CatBuilder.buildCat(from: catData)!
        XCTAssertEqual(cat.name, "testCat", "Builder should set name correctly from valid data")
        XCTAssertEqual(cat.identifier, 2, "Builder should set identifier correctly from valid data")
        XCTAssertEqual(cat.about, "I am a cat", "Builder should set about correctly from valid data")
        XCTAssertEqual(cat.age, 10, "Builder should set age correctly from valid data")
        XCTAssertEqual(cat.city, "Denver", "Builder should set city correctly from valid data")
        XCTAssertEqual(cat.stateCode, "CO", "Builder should set state code correctly from valid data")
        XCTAssertEqual(cat.cutenessLevel, 3, "Builder should set cuteness level correctly from valid data")
        XCTAssertEqual(cat.greeting, "Meooooow", "Builder should set greeting correctly from valid data")
        XCTAssertEqual(cat.weight, 10, "Builder should set weight correctly from valid data")
    }

    // MARK:- Specific Properties

    // Gender Property
    func testBuildingCatFromExternalCatWithSpecificGender() {

        var data = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.neutered, options: [])
        var cat = CatBuilder.buildCat(from: data)!
        XCTAssertEqual(cat.sex, .unknown, "Only 'male' and 'female' should return known sexes, otherwise should return unknown")

        data = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.male, options: [])
        cat = CatBuilder.buildCat(from: data)!
        XCTAssertEqual(cat.sex, .male, "Sex should be parsed correctly")

        data = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.female, options: [])
        cat = CatBuilder.buildCat(from: data)!
        XCTAssertEqual(cat.sex, .female, "Sex should be parsed correctly")
    }

    // ImageURL property

    func testBuildingCatFromExternalCatWithBadUrlString() {
        let data = try! JSONSerialization.data(withJSONObject: ExternalCatData.withBadURLString, options: [])
        let cat = CatBuilder.buildCat(from: data)!
        XCTAssertNil(cat.imageUrl, "Cat should not create url from bad url string")
    }

    func testBuildingCatFromExternalCatWithValidUrlString() {
        let data = try! JSONSerialization.data(withJSONObject: ExternalCatData.withURLString, options: [])
        let cat = CatBuilder.buildCat(from: data)!
        XCTAssertEqual(cat.imageUrl?.absoluteString, "https://example.com/foo.gif", "Cat should have valid url")
    }
}
