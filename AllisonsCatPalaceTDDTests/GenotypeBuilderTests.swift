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

    var rawData: Data!

    func testBuildingWithMissingSpecies() {
        buildDataFrom(rawData: SampleExternalGenotypeData.missingSpecies)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with missing species")
    }

    func testBuildingWithEmptySpecies() {
        buildDataFrom(rawData: SampleExternalGenotypeData.emptySpecies)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with empty species")
    }

    func testBuildingWithMissingPurity() {
        buildDataFrom(rawData: SampleExternalGenotypeData.missingPurity)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with missing purity")
    }

    func testBuildingWithEmptyPurity() {
        buildDataFrom(rawData: SampleExternalGenotypeData.emptyPurity)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with empty purity")
    }

    func testBuildingWithMissingBreedsElement() {
        buildDataFrom(rawData: SampleExternalGenotypeData.missingBreedsElement)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with missing breeds element")
    }

    func testBuildingWithMissingBreedElement() {
        buildDataFrom(rawData: SampleExternalGenotypeData.missingBreedElement)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with missing breed element")
    }

    // Should it build with an empty list of breeds?
    // Should that check go in the canonical genotype stuff?
    // made it not for now but worth considering
    func testBuildingWithEmptyBreedElement() {
        buildDataFrom(rawData: SampleExternalGenotypeData.emptyBreedElement)
        XCTAssertNil(GenotypeBuilder.build(from: rawData),
                     "Should not build genotype with empty breed element")
    }

    func testBuildingMixed() {
        buildDataFrom(rawData: SampleExternalGenotypeData.validMixed)
        XCTAssertNotNil(GenotypeBuilder.build(from: rawData))
    }

    func testBuildingPurebred() {
        buildDataFrom(rawData: SampleExternalGenotypeData.validPurebred)
        XCTAssertNotNil(GenotypeBuilder.build(from: rawData))
    }
}

private extension GenotypeBuilderTests {
    func buildDataFrom(rawData: ExternalGenotype) {
        self.rawData = try! JSONSerialization.data(withJSONObject: rawData, options: [])
    }
}
