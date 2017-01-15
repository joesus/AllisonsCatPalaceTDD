//
//  ExternalCatTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class ExternalCatTests: XCTestCase {

    var cat: ExternalCat!

    func testCreateExternalCatWithIdAndName() {
        cat = ExternalCat(name: "CatOne", identifier: 1)
        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testCreateExternalCatWithOutIdAndName() {
        cat = ExternalCat(name: nil, identifier: nil)
        XCTAssertNil(cat.name, "Cat name should be missing")
        XCTAssertNil(cat.identifier, "Cat Id should be missing")
    }

    func testCreateExternalCatWithOnlyName() {
        cat = ExternalCat(name: "CatOne", identifier: nil)
        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertNil(cat.identifier, "Cat Id should be missing")
    }

    func testCreateExternalCatWithOnlyId() {
        cat = ExternalCat(name: nil, identifier: 1)
        XCTAssertNil(cat.name, "Cat name should be missing")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }
}
