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

    func testBuildingExternalCatWithEmptyDictionary() {
        externalCat = CatBuilder.buildExternalCatFromJSON(CatData.invalid)
        XCTAssertNil(externalCat.name, "Cat name should be missing")
        XCTAssertNil(externalCat.identifier, "Cat Id should be missing")
    }

    func testBuildingExternalCatFromJSON() {
        externalCat = CatBuilder.buildExternalCatFromJSON(CatData.valid)
        XCTAssertEqual(externalCat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(externalCat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testBuildingCatFromValidExternalCat() {
        externalCat = CatBuilder.buildExternalCatFromJSON(CatData.valid)
        cat = CatBuilder.buildCatFromExternalCat(externalCat)
        guard let cat = cat else {
            return XCTFail("Cat should exist after being build from external cat")
        }

        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testBuildingCatFromExternalCatWithInvalidNameAndId() {
        externalCat = CatBuilder.buildExternalCatFromJSON(CatData.invalid)
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat name and id are nil")
    }
}

struct CatData {
    static let valid: [String: Any] = ["name": "CatOne", "id": 1]
    static let invalid: [String: Any] = [:]
}
