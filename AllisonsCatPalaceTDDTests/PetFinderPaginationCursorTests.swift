//
//  PetFinderPaginationCursorTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderPaginationCursorTests: PaginationCursorTests {

    func testPaginationQueryItemKeys() {
        XCTAssertEqual(PetFinderUrlBuilder.PaginationKeys.offset, "offset",
                       "There should be a defined name for each key")
        XCTAssertEqual(PetFinderUrlBuilder.PaginationKeys.count, "count",
                       "There should be a defined name for each key")
    }
    
    func testInitialPageQueryItems() {
        let expectedQueryItems: Set = [
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.offset,
                value: "0"
            ),
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.count,
                value: "20"
            )
        ]

        XCTAssertEqual(cursor.petFinderUrlQueryItems, expectedQueryItems,
                       "Cursor should be able to generate query items for PetFinder URL building")
    }

    func testCustomPageQueryItems() {
        cursor = PaginationCursor(size: 30, index: 2)
        let expectedQueryItems: Set = [
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.offset,
                value: "60"
            ),
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.count,
                value: "30"
            )
        ]

        XCTAssertEqual(cursor.petFinderUrlQueryItems, expectedQueryItems,
                       "Cursor should be able to generate query items for PetFinder URL building")
    }
}
