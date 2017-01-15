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
}
