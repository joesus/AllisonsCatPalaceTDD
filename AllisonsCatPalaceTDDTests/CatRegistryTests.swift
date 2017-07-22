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

    var completionHandlerInvoked = false

    override func setUp() {
        super.setUp()

        completionHandlerInvoked = false
        URLSession.beginSpyingOnDataTaskCreation()
        URLSessionDataTask.beginSpyingOnResume()
    }

    override func tearDown() {
        URLSession.endSpyingOnDataTaskCreation()
        URLSessionDataTask.endSpyingOnResume()

        super.tearDown()
    }

    func testGettingAllCatsFailure() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            self.completionHandlerInvoked = true
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssert(receivedCats!.isEmpty, "Should not have cats without data")
    }

    func testGettingAllCatsWithEmptyResult() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            self.completionHandlerInvoked = true
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler

        let emptyCatsData = try! JSONSerialization.data(withJSONObject: [], options: [])

        handler?(emptyCatsData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssert(receivedCats!.isEmpty, "Should not have cats with empty data")
    }

    func testGettingAllCatsSuccess() {
        var receivedCats: [Cat]?
        CatRegistry.fetchAllCats() { cats in
            self.completionHandlerInvoked = true
            receivedCats = cats
        }
        let handler = CatNetworker.session.capturedCompletionHandler

        let catData = try! JSONSerialization.data(withJSONObject: [SampleExternalCatData.valid, SampleExternalCatData.anotherValid], options: [])

        handler?(catData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertEqual(receivedCats!.count, 2, "Should have received two cats")
    }

    func testGetSingleCatFailure() {
        var retrievedCat: Cat?
        CatRegistry.fetchCat(withIdentifier: 2) { cat in
            self.completionHandlerInvoked = true
            retrievedCat = cat
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedCat, "Should not return a cat if there is no data")
    }

    func testGetSingleCatWithEmptyResult() {
        var retrievedCat: Cat?
        CatRegistry.fetchCat(withIdentifier: 1) { cat in
            self.completionHandlerInvoked = true
            retrievedCat = cat
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        let emptyData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        handler?(emptyData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedCat, "Should not return a cat if the data is empty")
    }

    func testGetSingleCatSuccess() {
        var retrievedCat: Cat?
        CatRegistry.fetchCat(withIdentifier: 1) { cat in
            self.completionHandlerInvoked = true
            retrievedCat = cat
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        let catData = try! JSONSerialization.data(withJSONObject: SampleExternalCatData.valid, options: [])

        handler?(catData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNotNil(retrievedCat, "Valid cat data should return a cat")
    }
}















