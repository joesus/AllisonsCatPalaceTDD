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

        URLSession.shared.lastResumedDataTask = nil
        URLSession.shared.lastCreatedDataTask = nil
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

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving cats should be get")
        XCTAssertEqual(request.url?.host, "example.com", "The domain should be example.com")
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

    func testHandlingMissingCatsEndpoint() {
        var receivedError: CatNetworkError?

        CatNetworker.retrieveAllCats { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Cat service unavailable", "missing cat endpoint should provide a service unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForAllCats() {
        var receivedError: CatNetworkError?

        CatNetworker.retrieveAllCats { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
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
        handler?(sampleData, response200(), nil)
        XCTAssertEqual(retrievedCatData, sampleData, "retrievedCatData should equal sample data")
    }

    func testCreatingRetrieveSingleCatTask() {
        CatNetworker.retrieveCat(withIdentifier: 2) {_ in}

        guard let task = CatNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a single cat should be get")
        XCTAssertEqual(request.url?.host, "example.com", "The domain should be example.com")
        XCTAssertEqual(request.url?.path, "/cats/2", "The path should be cats/{id}")
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testHandlingRetrieveSingleCatNetworkFailure() {
        var receivedError: NSError?

        CatNetworker.retrieveCat(withIdentifier: 2) { result in
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

        CatNetworker.retrieveCat(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Cat 1 not found", "missing cat should provide a cat unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForSingleCat() {
        var receivedError: CatNetworkError?

        CatNetworker.retrieveCat(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? CatNetworkError
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data", "cat retrieval with missing data and success code should fail")
    }

    func testRetrievingSingleCat() {
        var retrievedCatData: Data?
        let sampleData = Data(bytes: [0x1])

        CatNetworker.retrieveCat(withIdentifier: 1) { result in
            if case let .success(data) = result {
                retrievedCatData = data
            }
        }
        let handler = CatNetworker.session.capturedCompletionHandler
        handler?(sampleData, response200(), nil)
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
