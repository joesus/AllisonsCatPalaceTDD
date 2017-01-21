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

    func testBuildingCatFromValidExternalCat() {
        externalCat = CatData.valid
        cat = CatBuilder.buildCatFromExternalCat(externalCat)
        guard let cat = cat else {
            return XCTFail("Cat should exist after being build from external cat")
        }

        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testBuildingCatFromExternalCatWithMissingData() {
        externalCat = CatData.invalid
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat name and id are nil")
    }

    func testBuildingCatFromExternalCatWithMissingName() {
        externalCat = CatData.missingName
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat name is nil")
    }
    func testBuildingCatFromExternalCatWithMissingIdentifier() {
        externalCat = CatData.missingIdentifier
        XCTAssertNil(CatBuilder.buildCatFromExternalCat(externalCat), "Cat should not be constructed if externalCat id is nil")
    }
}

struct CatData {
    static let valid: [String: Any] = ["name": "CatOne", "id": 1]
    static let missingIdentifier: [String: Any] = ["name": "CatOne"]
    static let missingName: [String: Any] = ["id": 1]
    static let invalid: [String: Any] = [:]
}
