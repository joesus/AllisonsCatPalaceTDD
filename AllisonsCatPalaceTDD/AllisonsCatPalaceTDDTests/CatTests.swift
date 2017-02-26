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
    let catWithURLString = Cat(name: "CatURL", identifier: 1, urlString: "http://example.com/foo.png")

    func testCreateCat() {
        XCTAssertEqual(cat.name, "CatOne", "Cat name was set incorrectly")
        XCTAssertEqual(cat.identifier, 1, "Cat Id was set incorrectly")
    }

    func testCanCreateCatWithURLString() {
        XCTAssertNotNil(catWithURLString.urlString)
        XCTAssertEqual(catWithURLString.urlString, "http://example.com/foo.png", "Cat urlString was set incorrectly")
    }
}
