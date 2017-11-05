//
//  PaginationCursorTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/7/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PaginationCursorTests: XCTestCase {

    var cursor = PaginationCursor(size: 20)

    func testHasPageSize() {
        XCTAssertEqual(cursor.size, 20,
                       "Pagination cursor should have a page size of 20")
    }

    func testHasPageIndex() {
        XCTAssertEqual(cursor.index, 0,
                       "Pagination cursor has a default page index of zero")
    }

    func testCreatingWithNonDefaultIndex() {
        cursor = PaginationCursor(size: 20, index: 2)
        XCTAssertEqual(cursor.index, 2,
                       "Should be able to create a cursor with a non-default index")
    }

    func testPaginationOffsets() {
        XCTAssertEqual(cursor.offset, 0,
                       "The offset should be size times index")

        cursor = PaginationCursor(size: 30, index: 3)

        XCTAssertEqual(cursor.offset, 90,
                       "The offset should be size times index")
    }

    func testNextCursor() {
        cursor = PaginationCursor(size: 20)
        var next = cursor.nextPage()
        XCTAssertEqual(next.index, cursor.index + 1,
                       "The next cursor should be a cursor with an incremented index")
        XCTAssertEqual(next.size, cursor.size,
                       "The next cursor should not modify the page size")

        next = next.nextPage()
        XCTAssertEqual(next.index, cursor.index + 2,
                       "The next cursor should be a cursor with an incremented index")
        XCTAssertEqual(next.size, cursor.size,
                       "The next cursor should not modify the page size")
    }
}
