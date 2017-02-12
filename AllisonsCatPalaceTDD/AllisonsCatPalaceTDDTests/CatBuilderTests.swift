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

    var externalCat: ExternalCat!
    var cat: Cat?

    func testTransformingBadDataToCatList() {
        let badData = Data(bytes: [0x1])
        let catList = CatBuilder.externalCatList(from: badData)
        XCTAssertNil(catList, "catList should be nil with bad data")
    }

    func testTransformingEmptyDataToCatList() {
        let emptyData = try! JSONSerialization.data(withJSONObject: [], options: [])
        let catList = CatBuilder.externalCatList(from: emptyData)
        XCTAssertTrue(catList!.isEmpty, "Empty data should represent as an empty array")
    }

    func testTransformingValidCatDataToCatList() {
        let catData = try! JSONSerialization.data(withJSONObject: [ExternalCatData.valid], options: [])
        let catList = CatBuilder.externalCatList(from: catData)
        XCTAssertEqual(catList!.count, 1, "catlist should have one cat")
    }

    func testBuildingCatFromValidExternalCat() {
        externalCat = ExternalCatData.valid
        cat = CatBuilder.buildCatFromExternalCat(externalCat)
        guard let cat = cat else {
            return XCTFail("Cat should exist after being build from external cat")
        }

        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testBuildingCatFromExternalCatWithMissingData() {
        externalCat = ExternalCatData.invalid
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat name and id are nil")
    }

    func testBuildingCatFromExternalCatWithMissingName() {
        externalCat = ExternalCatData.missingName
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat name is nil")
    }
    func testBuildingCatFromExternalCatWithMissingIdentifier() {
        externalCat = ExternalCatData.missingIdentifier
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat id is nil")
    }
}
