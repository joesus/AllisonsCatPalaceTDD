//
//  ResultTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class ResultTests: XCTestCase {

    var result: Result<NSObject>!

    func testSuccessCase() {
        let object = NSObject()
        result = .success(object)
        if case let .success(thing) = result! {
            XCTAssertEqual(thing, object, "a success result should store it's associated value")
        } else {
            XCTFail("success should have an associated value")
        }
    }

    func testFailureCase() {
        let expectedError = NSError()
        result = .failure(expectedError)
        if case let .failure(error as NSError) = result! {
            XCTAssertEqual(error, expectedError, "a failure result should store it's associated value")
        } else {
            XCTFail("success should have an associated value")
        }
    }
}
