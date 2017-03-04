//
//  CatTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatTests: XCTestCase {

    let cat = Cat(name: "CatOne", identifier: 1)
    let catWithURL = Cat(name: "CatURL", identifier: 1, imageUrl: URL(string: "https://example.com/foo.gif"))

    func testCreateCat() {
        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testCanCreateCatWithURLString() {
        XCTAssertNotNil(catWithURL.imageUrl)
        XCTAssertEqual(catWithURL.imageUrl?.absoluteString, "https://example.com/foo.gif", "Cat url was set incorrectly")
    }
}
