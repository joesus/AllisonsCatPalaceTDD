//
//  FavoriteTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class FavoriteTests: XCTestCase {

    var favorite: Favorite! = Favorite(identifier: 2, category: "Hat", value: "CowboyHat")

    func testCannotCreateFavoriteWithEmptyCategory() {
        favorite = Favorite(identifier: 2, category: "", value: "CowboyHat")
        XCTAssertNil(favorite, "Should not create favorite with empty category")
    }

    func testCannotCreateFavoriteWithEmptyValue() {
        favorite = Favorite(identifier: 2, category: "Hat", value: "")
        XCTAssertNil(favorite, "Should not create favorite with empty value")
    }

    func testCreateFavorite() {
        XCTAssertEqual(favorite.identifier, 2, "Favorite identifier should be set correctly")
        XCTAssertEqual(favorite.category, "Hat", "Favorite category should be set incorrectly")
        XCTAssertEqual(favorite.value, "CowboyHat", "Favorite value should be set incorrectly")
    }
}
