//
//  AnimalNetworkerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalNetworkerTests: XCTestCase {

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
        XCTAssertEqual(AnimalNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllAnimalsTask() {
        AnimalNetworker.retrieveAllAnimals {_ in}

        guard let task = AnimalNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving cats should be get")
        XCTAssertEqual(request.url?.host, "api.petfinder.com", "The domain should be localhost")
        XCTAssertEqual(request.url?.path, "/shelter.getPets", "The path should be cats")
        // TODO - need test for path components / query params
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testNewRetrieveAllAnimalsTaskCancelsExistingTask() {
        AnimalNetworker.retrieveAllAnimals { _ in }

        guard let firstTask = AnimalNetworker.session.lastResumedDataTask else {
            fatalError("A task should have been created")
        }
        AnimalNetworker.retrieveAllAnimals { _ in }
        XCTAssertTrue(firstTask.cancelWasCalled, "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }

    func testHandlingRetrieveAllAnimalsNetworkFailure() {
        var receivedError: NSError?

        AnimalNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError, "the network error should be passed to the completion handler")
    }

    func testHandlingMissingAnimalsEndpoint() {
        var receivedError: AnimalNetworkError?

        AnimalNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Animal service unavailable", "missing animal endpoint should provide a service unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForAllAnimals() {
        var receivedError: AnimalNetworkError?

        AnimalNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data", "animal retrieval with missing data and success code should fail")
    }

    func testRetrievingAllAnimals() {
        var retrievedAnimalData: PetFinderResponse?
        let sampleData = PetFinderResponse(bytes: [0x1])

        AnimalNetworker.retrieveAllAnimals { result in
            if case let .success(data) = result {
                retrievedAnimalData = data
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(sampleData, response200(), nil)
        XCTAssertEqual(retrievedAnimalData, sampleData, "retrievedAnimalData should equal sample data")
    }

    func testCreatingRetrieveSingleAnimalTask() {
        AnimalNetworker.retrieveAnimal(withIdentifier: 2) {_ in}

        guard let task = AnimalNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a single animal should be get")
        XCTAssertEqual(request.url?.host, "api.petfinder.com", "The domain should be localhost")
        XCTAssertEqual(request.url?.path, "/shelter.getPets/2", "The path should be animals/{id}")
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testHandlingRetrieveSingleAnimalNetworkFailure() {
        var receivedError: NSError?

        AnimalNetworker.retrieveAnimal(withIdentifier: 2) { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError, "the network error should be passed to the completion handler")
    }

    func testHandlingMissingAnimalEndpoint() {
        var receivedError: AnimalNetworkError?

        AnimalNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Animal 1 not found", "missing animal should provide an animal unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForSingleAnimal() {
        var receivedError: AnimalNetworkError?

        AnimalNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data", "animal retrieval with missing data and success code should fail")
    }

    func testRetrievingSingleAnimal() {
        var retrievedAnimalData: PetFinderResponse?
        let sampleData = PetFinderResponse(bytes: [0x1])

        AnimalNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .success(data) = result {
                retrievedAnimalData = data
            }
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(sampleData, response200(), nil)
        XCTAssertEqual(retrievedAnimalData, sampleData, "retrievedAnimalData should equal sample data")
    }
}

extension AnimalNetworkerTests {

    func hasDataTask() -> Bool {
        var hasTasks = false

        AnimalNetworker.session.getAllTasks { tasks in
            hasTasks = !tasks.isEmpty
        }
        return hasTasks
    }
}

enum TestError: Error {
    case error
}
