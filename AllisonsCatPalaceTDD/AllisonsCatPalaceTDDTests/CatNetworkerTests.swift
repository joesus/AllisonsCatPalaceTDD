//
//  CatNetworkerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatNetworkerTests: XCTestCase {

    var taskRetrievalExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        URLSessionTask.beginSpyingOnResume()
        URLSessionTask.beginSpyingOnCancel()
        URLSession.beginSpyingOnDataTaskCreation()
    }

    override func tearDown() {
        URLSessionTask.endSpyingOnResume()
        URLSessionTask.endSpyingOnCancel()
        URLSession.endSpyingOnDataTaskCreation()

        super.tearDown()
    }

    func testNetworkerSessionIsSharedSession() {
        XCTAssertEqual(CatNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllCatsTask() {
        CatNetworker.retrieveAllCats {_ in}

        guard let task = CatNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a cat should be get")
        XCTAssertEqual(request.url?.host, "example.com", "The domain should be firebase")
        XCTAssertEqual(request.url?.path, "/cats", "The path should be cats")
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testNewRetrieveAllCatsTaskCancelsExistingTask() {
        CatNetworker.retrieveAllCats { _ in }

        guard let firstTask = CatNetworker.session.lastResumedDataTask else {
            fatalError("A task should have been created")
        }
        CatNetworker.retrieveAllCats { _ in }
        XCTAssertTrue(firstTask.cancelWasCalled, "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }

    func testHandlingRetrieveAllCatsNetworkFailure() {
        var receivedError: NSError?

        CatNetworker.retrieveAllCats { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError, "the network error should be passed to the completion handler")
    }

    func testHandlingMissingCatEndpoint() {
        var receivedError: CatNetworkError?

        CatNetworker.retrieveAllCats { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, missingCatResponse, nil)
        XCTAssertEqual(receivedError?.message, "Cat service unavailable", "missing cat endpoint should provide a service unavailable message")
    }

    func testHandlingMissingDataWithValidResponse() {
        var receivedError: CatNetworkError?

        CatNetworker.retrieveAllCats { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, successfulCatResponse, nil)
        XCTAssertEqual(receivedError?.message, "Missing Data", "cat retrieval with missing data and success code should fail")
    }

    func testRetrievingAllCats() {
        var retrievedCatData: Data?
        let sampleData = Data(bytes: [0x1])

        CatNetworker.retrieveAllCats { result in
            if case let .success(data) = result {
                retrievedCatData = data
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(sampleData, successfulCatResponse, nil)
        XCTAssertEqual(retrievedCatData, sampleData, "retrievedCatData should equal sample data")
    }

}

extension CatNetworkerTests {

    func hasDataTask() -> Bool {
        var hasTasks = false

        CatNetworker.session.getAllTasks { tasks in
            hasTasks = !tasks.isEmpty
        }
        return hasTasks
    }
}

enum TestError: Error {
    case error
}