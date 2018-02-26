//
//  GenotypeBuilderTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//
@testable import AllisonsCatPalaceTDD
import XCTest

class GenotypeBuilderTests: XCTestCase {

    var rawData: PetFinderResponse!

    func testBuildingWithMissingSpecies() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.missingSpecies),
                     "Should not build genotype with missing species")
    }

    func testBuildingWithEmptySpecies() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.emptySpecies),
                     "Should not build genotype with empty species")
    }

    func testBuildingWithMissingPurity() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.missingPurity),
                     "Should not build genotype with missing purity")
    }

    func testBuildingWithEmptyPurity() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.emptyPurity),
                     "Should not build genotype with empty purity")
    }

    func testBuildingWithMissingBreedsElement() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.missingBreedsElement),
                     "Should not build genotype with missing breeds element")
    }

    func testBuildingWithMissingBreedElement() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.missingBreedElement),
                     "Should not build genotype with missing breed element")
    }

    // Should it build with an empty list of breeds?
    // Should that check go in the canonical genotype stuff?
    // made it not for now but worth considering
    func testBuildingWithEmptyBreedElement() {
        XCTAssertNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.emptyBreedElement),
                     "Should not build genotype with empty breed element")
    }

    func testBuildingMixed() {
        XCTAssertNotNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.validMixed))
    }

    func testBuildingPurebred() {
        XCTAssertNotNil(GenotypeBuilder.build(from: SampleExternalGenotypeData.validPurebred))
    }
}
