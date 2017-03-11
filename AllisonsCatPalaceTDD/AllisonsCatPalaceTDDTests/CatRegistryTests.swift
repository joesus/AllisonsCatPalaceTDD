//
//  CatDataSourceTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatRegistryTests: XCTestCase {

    override func setUp() {
        super.setUp()

        URLSession.beginSpyingOnDataTaskCreation()
        URLSessionDataTask.beginSpyingOnResume()
    }

    override func tearDown() {
        URLSessionDataTask.endSpyingOnResume()
        URLSession.endSpyingOnDataTaskCreation()

        super.tearDown()
    }

    func testGettingAllCatsFailure() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssert(receivedCats!.isEmpty, "Should not have cats without data")
    }

    func testGettingAllCatsWithEmptyResult() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler

        let emptyCatsData = try! JSONSerialization.data(withJSONObject: [], options: [])

        handler?(emptyCatsData, response200(), nil)

        XCTAssert(receivedCats!.isEmpty, "Should not have cats with empty data")
    }

    func testGettingAllCatsSuccess() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler

        let catData = try! JSONSerialization.data(withJSONObject: [ExternalCatData.valid, ExternalCatData.anotherValid], options: [])

        handler?(catData, response200(), nil)

        XCTAssertEqual(receivedCats!.count, 2, "Should have received two cats")
    }
}
