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
        let catData = try! JSONSerialization.data(withJSONObject: [SampleExternalCatData.valid, SampleExternalCatData.anotherValid], options: [])
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
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.missingName, options: [])
        let cat = CatBuilder.buildCat(from: catData)
        XCTAssertNil(cat, "Should not create cat if name is missing")
    }

    // Partial Data (with name)
    func testBuildingCatWithMissingIdentifier() {
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.missingIdentifier, options: [])
        let cat = CatBuilder.buildCat(from: catData)
        XCTAssertNil(cat, "Should not create cat if identifier is missing")
    }

    // Minimal Data
    func testBuildingCatWithMinimalData() {
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.valid, options: [])
        let cat = CatBuilder.buildCat(from: catData)!
        XCTAssertEqual(cat.name, "CatOne", "Builder should set name correctly from valid data")
        XCTAssertEqual(cat.identifier, 1, "Builder should set identifier correctly from valid data")
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

    // Image Locations
    func testBuildingCatWithoutMedia() {
        let data = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.valid, options: [])
        guard let cat = CatBuilder.buildCat(from: data) else {
            return XCTFail("Should be able to create cat without media")
        }
        XCTAssertEqual(cat.imageLocations.small, [],
                       "Cat should not create small images without media")
        XCTAssertEqual(cat.imageLocations.medium, [],
                       "Cat should not create medium images without media")
        XCTAssertEqual(cat.imageLocations.large, [],
                       "Cat should not create large images without media")
    }

    func testBuildingCatWithEmptyMedia() {
        var validWithEmptyMedia = SampleExternalCatData.valid
        validWithEmptyMedia[ExternalCatKeys.media] = [String: Any]()
        let data = try! JSONSerialization.data(withJSONObject: validWithEmptyMedia, options: [])
        guard let cat = CatBuilder.buildCat(from: data) else {
            return XCTFail("Should be able to create cat with empty media")
        }
        XCTAssertEqual(cat.imageLocations.small, [],
                       "Cat should not create small images with empty media")
        XCTAssertEqual(cat.imageLocations.medium, [],
                       "Cat should not create medium images with empty media")
        XCTAssertEqual(cat.imageLocations.large, [],
                       "Cat should not create large images with empty media")
    }

    func testBuildingCatWithEmptyPhotoContainer() {
        var validWithEmptyPhotoContainer = SampleExternalCatData.valid
        validWithEmptyPhotoContainer[ExternalCatKeys.media] = [
            ExternalCatKeys.photos: [
                ExternalCatKeys.photo: []
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: validWithEmptyPhotoContainer, options: [])
        guard let cat = CatBuilder.buildCat(from: data) else {
            return XCTFail("Should be able to create cat with empty photos")
        }
        XCTAssertEqual(cat.imageLocations.small, [],
                       "Cat should not create small images with empty photos")
        XCTAssertEqual(cat.imageLocations.medium, [],
                       "Cat should not create medium images with empty photos")
        XCTAssertEqual(cat.imageLocations.large, [],
                       "Cat should not create large images with empty photos")
    }

    func testBuildingCatWithPhotos() {
        let expectedUrls = [URL(string: SampleExternalCatData.validImageUrlString)!]
        var validWithPhotos = SampleExternalCatData.valid
        validWithPhotos[ExternalCatKeys.media] = [
            ExternalCatKeys.photos: [
                ExternalCatKeys.photo: SampleExternalCatData.photos
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: validWithPhotos, options: [])
        guard let cat = CatBuilder.buildCat(from: data) else {
            return XCTFail("Should be able to create cat with empty photos")
        }
        XCTAssertEqual(cat.imageLocations.small, expectedUrls,
                       "Cat should create small images with valid photo strings")
        XCTAssertEqual(cat.imageLocations.medium, expectedUrls,
                       "Cat should create medium images with valid photo strings")
        XCTAssertEqual(cat.imageLocations.large, expectedUrls,
                       "Cat should create large images with valid photo strings")
    }

    func testBuildingCatWithoutAdoptionStatus() {
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.valid, options: [])
        guard let cat = CatBuilder.buildCat(from: catData) else {
            return XCTFail("Should be able to create cat without adoption status")
        }
        XCTAssertNil(cat.adoptionStatus, "Adoption status should be nil when status is missing")
    }

    func testBuildingCatWithEmptyAdoptionStatus() {
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.emptyStatus, options: [])
        guard let cat = CatBuilder.buildCat(from: catData) else {
            return XCTFail("Should be able to create cat without adoption status")
        }
        XCTAssertNil(cat.adoptionStatus, "Adoption status should be nil when status is missing")
    }

    // Full Data
    func testBuildingCatWithFullData() {
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.full, options: [])
        let cat = CatBuilder.buildCat(from: catData)!
        XCTAssertEqual(cat.name, "CatTwo", "Builder should set name correctly from valid data")
        XCTAssertEqual(cat.identifier, 2, "Builder should set identifier correctly from valid data")
        XCTAssertEqual(cat.about, "I am a cat", "Builder should set about correctly from valid data")
        XCTAssertEqual(cat.age, .young, "Builder should set age correctly from valid data")
        XCTAssertEqual(cat.city, "Denver", "Builder should set city correctly from valid data")
        XCTAssertEqual(cat.stateCode, "CO", "Builder should set state code correctly from valid data")
        XCTAssertEqual(cat.size, .large, "Builder should set size correctly from valid data")
        XCTAssertEqual(cat.adoptionStatus, .adoptable, "Builder should set adoptability from valid data")
    }

}
