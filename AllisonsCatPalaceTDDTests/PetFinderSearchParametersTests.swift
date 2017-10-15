//
//  PetFinderSearchParametersTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderSearchParametersTests: XCTestCase {

    func testSearchParameterKeys() {
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.location, "location",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.species, "animal",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.breed, "breed",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.size, "size",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.sex, "sex",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderSearchParameters.QueryItemKeys.age, "age",
                       "There should be a defined name for each key")
    }

    func testParametersIncludeZipCode() {
        XCTAssertEqual(
            SampleSearchParameters.zipCodeOnly.zipCode,
            SampleSearchParameters.zipCode,
            "Parameters include a zip code"
        )

        XCTAssertEqual(
            SampleSearchParameters.zipCodeOnly.queryItems,
            [SampleSearchParameters.zipCodeQueryItem],
            "Parameters should provide query items"
        )
    }

    func testParametersDoNotRequireSpecies() {
        XCTAssertNil(SampleSearchParameters.zipCodeOnly.species, "Parameters do not require a species")
    }

    func testParametersMayIncludeSpecies() {
        let parameters = PetFinderSearchParameters(
            zipCode: SampleSearchParameters.zipCode,
            species: .cat
        )
        XCTAssertEqual(parameters.species, .cat,
                       "Parameters may include a species")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.speciesQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }

    func testParametersDoNotRequireAnimalBreed() {
        XCTAssertNil(SampleSearchParameters.zipCodeOnly.breed, "Parameters do not require a breed")
    }

    func testParametersMayIncludeBreed() {
        let parameters = PetFinderSearchParameters(
            zipCode: SampleSearchParameters.zipCode,
            breed: "egyptian"
        )
        XCTAssertEqual(parameters.breed, "egyptian",
                       "Parameters may include a breed")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.breedQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }

    func testParametersDoNotRequireAnimalSize() {
        XCTAssertNil(SampleSearchParameters.zipCodeOnly.size, "Parameters do not require a size")
    }

    func testParametersMayIncludeAnimalSize() {
        let parameters = PetFinderSearchParameters(
            zipCode: SampleSearchParameters.zipCode,
            size: .medium
        )
        XCTAssertEqual(parameters.size, .medium,
                       "Parameters may include a size")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.sizeQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }

    func testParametersDoNotRequireAnimalAge() {
        XCTAssertNil(SampleSearchParameters.zipCodeOnly.age, "Parameters do not require an age")
    }

    func testParametersMayIncludeAnimalAge() {
        let parameters = PetFinderSearchParameters(
            zipCode: SampleSearchParameters.zipCode,
            age: .adult
        )
        XCTAssertEqual(parameters.age, .adult,
                       "Parameters may include an age")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.ageQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }

    func testParametersDoNotRequireAnimalSex() {
        XCTAssertNil(SampleSearchParameters.zipCodeOnly.sex, "Parameters do not require a sex")
    }

    func testParametersMayIncludeAnimalSex() {
        let parameters = PetFinderSearchParameters(
            zipCode: SampleSearchParameters.zipCode,
            sex: .female
        )
        XCTAssertEqual(parameters.sex, .female,
                       "Parameters may include a sex")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.sexQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }

    func testCreatingWithAllFields() {
        let parameters = SampleSearchParameters.fullSearchOptions

        XCTAssertEqual(parameters.zipCode, SampleSearchParameters.zipCode,
                       "Parameters should be created with provided zip code")
        XCTAssertEqual(parameters.species, .cat,
                       "Parameters should be created with provided species")
        XCTAssertEqual(parameters.breed, "egyptian",
                       "Parameters should be created with provided breed")
        XCTAssertEqual(parameters.size, .medium,
                       "Parameters should be created with provided size")
        XCTAssertEqual(parameters.age, .adult,
                       "Parameters should be created with provided age")
        XCTAssertEqual(parameters.sex, .female,
                       "Parameters should be created with provided sex")

        let queryItems = Set(parameters.queryItems)
        let expected = Set(
            [
                SampleSearchParameters.zipCodeQueryItem,
                SampleSearchParameters.speciesQueryItem,
                SampleSearchParameters.breedQueryItem,
                SampleSearchParameters.ageQueryItem,
                SampleSearchParameters.sizeQueryItem,
                SampleSearchParameters.sexQueryItem
            ]
        )
        XCTAssertEqual(queryItems, expected,
                       "Parameters should provide query items")
    }
}
