//
//  AnimalGenotypeTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalGenotypeTests: XCTestCase {

    var genotype: AnimalGenotype!
    let breeds = ["terrier", "Lab", "CALICO"]

    func testGenotypeHasSpecies() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .mixed,
            breeds: ["Foobar"]
        )
        XCTAssertEqual(genotype.species, .cat,
                       "Animal genotype should have species")
    }

    func testCreatingPurebredWithoutBreeds() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .purebred,
            breeds: []
        )
        XCTAssertNil(genotype, "Should not create purebred without breeds")
    }

    func testCreatingPurebredWithMultipleBreeds() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .purebred,
            breeds: breeds
        )
        XCTAssertNil(genotype, "Should not create purebred with multiple")
    }

    func testCreatingPurebredWithSingleBreed() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .purebred,
            breeds: ["Cat breed"]
        )
        guard let genotype = genotype else {
            return XCTFail("Should create a genotype with a single breed")
        }
        XCTAssertEqual(genotype.purity, .purebred,
                       "Should set purity correctly")
        XCTAssertEqual(genotype.breeds, ["Cat breed"],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithoutBreeds() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .mixed,
            breeds: []
        )
        guard let genotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with no breeds")
        }
        XCTAssertEqual(genotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(genotype.breeds, [],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithSingleBreed() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .mixed,
            breeds: ["Cat Breed"]
        )
        guard let genotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with a single breed")
        }
        XCTAssertEqual(genotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(genotype.breeds, ["Cat Breed"],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithMultipleBreeds() {
        genotype = AnimalGenotype(
            species: .cat,
            purity: .mixed,
            breeds: breeds
        )
        guard let genotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with multiple breeds")
        }
        XCTAssertEqual(genotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(genotype.breeds, breeds,
                       "Should set breeds correctly")
    }
}
