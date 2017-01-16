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
    }

    func testBuildingCatFromInvalidExternalCat() {
    }

}

struct CatData {
    static let valid: [String: Any] = ["name": "CatOne", "id": 1]
    static let invalid: [String: Any] = [:]
}
