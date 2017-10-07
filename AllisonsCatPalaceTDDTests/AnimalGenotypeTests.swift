//
//  AnimalGenotypeTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AllisonsCatPalaceTDD

class AnimalGenotypeTests: XCTestCase {

    var realm: Realm!

    var genotype: AnimalGenotype!

    override func setUp() {
        super.setUp()

        guard let sample = SampleGenotypes.mixedCatNoBreeds else {
            return XCTFail("Should create a genotype with for mixed with no breeds")
        }
        genotype = sample

        realm = realmForTest(withName: name!)
        reset(realm)
    }

    func testGenotypeHasSpecies() {
        XCTAssertEqual(genotype.species, .cat,
                       "Animal genotype should have species")
    }

    func testCreatingPurebredWithoutBreeds() {
        genotype = SampleGenotypes.purebredCatNoBreeds
        
        XCTAssertNil(genotype, "Should not create purebred without breeds")
    }

    func testCreatingPurebredWithMultipleBreeds() {
        genotype = SampleGenotypes.purebredCatMultipleBreeds

        XCTAssertNil(genotype, "Should not create purebred with multiple")
    }

    func testCreatingPurebredWithSingleBreed() {
        genotype = SampleGenotypes.purebredCatSingleBreed

        guard let validGenotype = genotype else {
            return XCTFail("Should create a genotype with a single breed")
        }
        XCTAssertEqual(validGenotype.purity, .purebred,
                       "Should set purity correctly")
        XCTAssertEqual(validGenotype.breeds, ["Cat breed"],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithoutBreeds() {
        XCTAssertEqual(genotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(genotype.breeds, [],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithSingleBreed() {
        genotype = SampleGenotypes.mixedCatSingleBreed

        guard let validGenotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with a single breed")
        }
        XCTAssertEqual(validGenotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(validGenotype.breeds, ["Cat Breed"],
                       "Should set breeds correctly")
    }

    func testCreatingMixedWithMultipleBreeds() {
        genotype = SampleGenotypes.mixedCatMultipleBreeds

        guard let validGenotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with multiple breeds")
        }
        XCTAssertEqual(validGenotype.purity, .mixed,
                       "Should set purity correctly")
        XCTAssertEqual(validGenotype.breeds, SampleGenotypes.breeds,
                       "Should set breeds correctly")
    }

    func testManagedObject() {
        XCTAssertEqual(AnimalGenotypeObject().species, nil,
                       "AnimalGenotypeObject should have no species by default")
        XCTAssertEqual(AnimalGenotypeObject().purity, nil,
                       "AnimalGenotypeObject should have no purity by default")

        genotype = AnimalGenotype(
            species: .cat,
            purity: .mixed,
            breeds: SampleGenotypes.breeds
        )
        guard let validGenotype = genotype else {
            return XCTFail("Should create a genotype with for mixed with multiple breeds")
        }

        let breedsData = NSKeyedArchiver.archivedData(withRootObject: SampleGenotypes.breeds)
        XCTAssertEqual(validGenotype.species.rawValue, validGenotype.managedObject.species!.value.value,
                       "Managed object for genotype should store correct raw value for species")
        XCTAssertEqual(validGenotype.purity.rawValue, validGenotype.managedObject.purity!.value.value,
                       "Managed object for genotype should store correct raw value for genetic purity")
        XCTAssertEqual(breedsData, validGenotype.managedObject.breeds,
                       "Managed object for genotype should store correct data for breeds")
    }

    func testInitializingFromManagedObject() {
        let managed = genotype.managedObject

        let objectFromManaged = AnimalGenotype(managedObject: managed)

        XCTAssertEqual(genotype.species, objectFromManaged?.species,
                       "Genotype instantiated from managed object should have correct species")
        XCTAssertEqual(genotype.purity, objectFromManaged?.purity,
                       "Genotype instantiated from managed object should have correct purity")
        XCTAssertEqual(genotype.breeds, objectFromManaged!.breeds,
                       "Genotype instantiated from managed object should have correct breeds")
    }

    func testSavingManagedObject() {
        let managed = genotype.managedObject

        try! realm.write {
            realm.add(managed)
        }

        let fetchedManagedObject = realm.objects(AnimalGenotypeObject.self).last!

        let originalValueFromFetched = AnimalGenotype(managedObject: fetchedManagedObject)

        XCTAssertEqual(genotype.species, originalValueFromFetched?.species,
                       "Genotype instantiated from fetched managed object should have correct species")
        XCTAssertEqual(genotype.purity, originalValueFromFetched?.purity,
                       "Genotype instantiated from fetched managed object should have correct purity")
    }

}
