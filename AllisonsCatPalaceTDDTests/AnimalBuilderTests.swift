//
//  AnimalBuilderTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalBuilderTests: XCTestCase {

    // MARK:- List tests

    // Bad Data
    func testTransformingBadDataToArrayOfAnimals() {
        let badData = Data(bytes: [0x1])
        let animals = AnimalBuilder.buildAnimals(from: badData)
        XCTAssertTrue(animals.isEmpty, "bad data should produce empty list of animals")
    }

    // Empty Data
    func testTransformingEmptyDataToAnimalList() {
        let emptyData = try! JSONSerialization.data(withJSONObject: [], options: [])
        let animals = AnimalBuilder.buildAnimals(from: emptyData)
        XCTAssertTrue(animals.isEmpty, "Empty data should produce empty list of animals")
    }

    // Minimal Data
    func testBuildingAnimalsFromMinimalAnimalData() {
        let externalData = SampleExternalAnimalData.wrap(
            animals: [
                SampleExternalAnimalData.valid,
                SampleExternalAnimalData.anotherValid
            ]
        )
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        let animals = AnimalBuilder.buildAnimals(from: animalData)
        let animalOne = animals.first!
        XCTAssertEqual(animalOne.name, "CatOne", "First animal name was set incorrectly")
        XCTAssertEqual(animalOne.identifier, 1, "First animal Id was set incorrectly")
        let animalTwo = animals.last!
        XCTAssertEqual(animalTwo.name, "CatTwo", "Second animal name was set incorrectly")
        XCTAssertEqual(animalTwo.identifier, 2, "Second animal Id was set incorrectly")
    }

    // MARK:- Single tests

    // Bad Data
    func testTransformingBadDataToAnimal() {
        let badData = PetFinderResponse(bytes: [0x1])
        let animal = AnimalBuilder.buildAnimal(from: badData)
        XCTAssertNil(animal, "Should not create animal with bad data")
    }

    // Missing Data
    func testTransformingEmptyDataToAnimal() {
        let emptyData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        let animal = AnimalBuilder.buildAnimal(from: emptyData)
        XCTAssertNil(animal, "Should not create animal with empty data")
    }

    // Partial Data (with Id)
    func testBuildingAnimalWithMissingName() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.missingName)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        let animal = AnimalBuilder.buildAnimal(from: animalData)
        XCTAssertNil(animal, "Should not create animal if name is missing")
    }

    // Partial Data (with name)
    func testBuildingAnimalWithMissingIdentifier() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.missingIdentifier)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        let animal = AnimalBuilder.buildAnimal(from: animalData)
        XCTAssertNil(animal, "Should not create animal if identifier is missing")
    }

    // Minimal Data
    func testBuildingAnimalWithMinimalData() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.valid)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        let animal = AnimalBuilder.buildAnimal(from: animalData)!
        XCTAssertEqual(animal.name, "CatOne", "Builder should set name correctly from valid data")
        XCTAssertEqual(animal.identifier, 1, "Builder should set identifier correctly from valid data")
    }

    // MARK:- Specific Properties

    // Gender Property
    func testBuildingAnimalFromExternalAnimalWithSpecificGender() {
        var externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.neutered)
        var data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        var animal = AnimalBuilder.buildAnimal(from: data)!
        XCTAssertEqual(animal.sex, .unknown, "Only 'male' and 'female' should return known sexes, otherwise should return unknown")

        externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.male)
        data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        animal = AnimalBuilder.buildAnimal(from: data)!
        XCTAssertEqual(animal.sex, .male, "Sex should be parsed correctly")

        externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.female)
        data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        animal = AnimalBuilder.buildAnimal(from: data)!
        XCTAssertEqual(animal.sex, .female, "Sex should be parsed correctly")
    }

    // Image Locations
    func testBuildingAnimalWithoutMedia() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.valid)
        let data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: data) else {
            return XCTFail("Should be able to create animal without media")
        }
        XCTAssertEqual(animal.imageLocations.small, [],
                       "Animal should not create small images without media")
        XCTAssertEqual(animal.imageLocations.medium, [],
                       "Animal should not create medium images without media")
        XCTAssertEqual(animal.imageLocations.large, [],
                       "Animal should not create large images without media")
    }

    func testBuildingAnimalWithEmptyMedia() {
        var validWithEmptyMedia = SampleExternalAnimalData.valid
        validWithEmptyMedia[ExternalAnimalKeys.media] = [String: Any]()

        let externalData = SampleExternalAnimalData.wrap(animal: validWithEmptyMedia)
        let data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: data) else {
            return XCTFail("Should be able to create animal with empty media")
        }
        XCTAssertEqual(animal.imageLocations.small, [],
                       "Animal should not create small images with empty media")
        XCTAssertEqual(animal.imageLocations.medium, [],
                       "Animal should not create medium images with empty media")
        XCTAssertEqual(animal.imageLocations.large, [],
                       "Animal should not create large images with empty media")
    }

    func testBuildingAnimalWithEmptyPhotoContainer() {
        var validWithEmptyPhotoContainer = SampleExternalAnimalData.valid
        validWithEmptyPhotoContainer[ExternalAnimalKeys.media] = [
            ExternalAnimalKeys.photos: [
                ExternalAnimalKeys.photo: []
            ]
        ]

        let externalData = SampleExternalAnimalData.wrap(animal: validWithEmptyPhotoContainer)
        let data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: data) else {
            return XCTFail("Should be able to create animal with empty photos")
        }
        XCTAssertEqual(animal.imageLocations.small, [],
                       "Animal should not create small images with empty photos")
        XCTAssertEqual(animal.imageLocations.medium, [],
                       "Animal should not create medium images with empty photos")
        XCTAssertEqual(animal.imageLocations.large, [],
                       "Animal should not create large images with empty photos")
    }

    func testBuildingAnimalWithPhotos() {
        let expectedUrls = [URL(string: SampleExternalAnimalData.validImageUrlString)!]
        var validWithPhotos = SampleExternalAnimalData.valid
        validWithPhotos[ExternalAnimalKeys.media] = [
            ExternalAnimalKeys.photos: [
                ExternalAnimalKeys.photo: SampleExternalAnimalData.photos
            ]
        ]

        let externalData = SampleExternalAnimalData.wrap(animal: validWithPhotos)
        let data = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: data) else {
            return XCTFail("Should be able to create animal with empty photos")
        }
        XCTAssertEqual(animal.imageLocations.small, expectedUrls,
                       "Animal should create small images with valid photo strings")
        XCTAssertEqual(animal.imageLocations.medium, expectedUrls,
                       "Animal should create medium images with valid photo strings")
        XCTAssertEqual(animal.imageLocations.large, expectedUrls,
                       "Animal should create large images with valid photo strings")
    }

    func testBuildingAnimalWithoutAdoptionStatus() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.valid)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: animalData) else {
            return XCTFail("Should be able to create animal without adoption status")
        }
        XCTAssertNil(animal.adoptionStatus, "Adoption status should be nil when status is missing")
    }

    func testBuildingAnimalWithEmptyAdoptionStatus() {
        let externalData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.emptyStatus)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        guard let animal = AnimalBuilder.buildAnimal(from: animalData) else {
            return XCTFail("Should be able to create animal without adoption status")
        }
        XCTAssertNil(animal.adoptionStatus, "Adoption status should be nil when status is missing")
    }

    // Full Data
    func testBuildingAnimalWithFullData() {
        var sampleAnimal = SampleExternalAnimalData.full
        SampleExternalGenotypeData.validMixed.keys.forEach { key in
            sampleAnimal.updateValue(SampleExternalGenotypeData.validMixed[key] as Any, forKey: key)
        }
        let externalData = SampleExternalAnimalData.wrap(animal: sampleAnimal)
        let animalData = try! JSONSerialization.data(withJSONObject: externalData, options: [])
        let animal = AnimalBuilder.buildAnimal(from: animalData)!
        XCTAssertEqual(animal.name, "CatTwo", "Builder should set name correctly from valid data")
        XCTAssertEqual(animal.identifier, 2, "Builder should set identifier correctly from valid data")
        XCTAssertEqual(animal.about, "I am a cat", "Builder should set about correctly from valid data")
        XCTAssertEqual(animal.age, .young, "Builder should set age correctly from valid data")
        XCTAssertEqual(animal.city, "Denver", "Builder should set city correctly from valid data")
        XCTAssertEqual(animal.stateCode, "CO", "Builder should set state code correctly from valid data")
        XCTAssertEqual(animal.size, .large, "Builder should set size correctly from valid data")
        XCTAssertEqual(animal.adoptionStatus, .adoptable, "Builder should set adoptability from valid data")
        XCTAssertEqual(animal.genotype?.species, .cat, "Builder should set species correctly")
        XCTAssertEqual(animal.genotype?.purity, .mixed, "Builder should set genetic purity correctly")
        XCTAssertEqual(animal.genotype?.breeds ?? [], ["Domestic Short Hair (Black & White)", "Tabby (Orange)"], "Builder should set breeds correctly")
    }

}
