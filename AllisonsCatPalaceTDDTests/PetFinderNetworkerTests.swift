// swiftlint:disable force_try vertical_parameter_alignment_on_call
//
//  PetFinderNetworkerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderNetworkerTests: XCTestCase {

    var taskRetrievalExpectation: XCTestExpectation!
    let cursor = PaginationCursor(size: 20)

    override func setUp() {
        super.setUp()

        URLSession.shared.lastResumedDataTask = nil
        URLSession.shared.lastCreatedDataTask = nil
        URLSessionTask.beginSpyingOnResume()
        URLSessionTask.beginSpyingOnCancel()
        URLSession.beginSpyingOnDataTaskCreation()
        SettingsManager.shared.clear()
    }

    override func tearDown() {
        URLSessionTask.endSpyingOnResume()
        URLSessionTask.endSpyingOnCancel()
        URLSession.endSpyingOnDataTaskCreation()
        SettingsManager.shared.clear()

        super.tearDown()
    }

    func testNetworkerSessionIsSharedSession() {
        XCTAssertEqual(PetFinderNetworker.session, URLSession.shared,
                       "Networker should be using the shared session")
    }

    func testCreatingFindAnimalsTask() {
        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { _ in }

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest
            else {
                return XCTFail("A task should have a currentRequest")
        }

        let expectedUrl = PetFinderUrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.minimalSearchOptions,
            range: cursor
        )

        XCTAssertEqual(expectedUrl, request.url,
                       "Finding animals should use the url returned by the url builder")
    }

    func testNewFindAnimalsTaskCancelsExistingTask() {
        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { _ in }

        guard let firstTask = PetFinderNetworker.session.lastResumedDataTask else {
            fatalError("A task should have been created")
        }

        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { _ in }

        XCTAssertTrue(firstTask.cancelWasCalled,
                      "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }

    func testHandlingFindAnimalsNetworkFailure() {
        var receivedError: NSError?

        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }

        PetFinderNetworker.session.capturedCompletionHandler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError,
                       "The network error should be passed to the completion handler")
    }

    func testHandlingMissingFindAnimalsEndpoint() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }

        PetFinderNetworker.session.capturedCompletionHandler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Animal service unavailable",
                       "Missing animal endpoint should provide a service unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForFindAnimals() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }

        PetFinderNetworker.session.capturedCompletionHandler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data",
                       "Animal retrieval with missing data and success code should fail")
    }

    func testFindingAnimals() {
        var retrievedAnimalData: PetFinderResponse?
        let sampleData = try! JSONSerialization.data(withJSONObject: [:], options: [])

        PetFinderNetworker.findAnimals(
            matching: SampleSearchParameters.minimalSearchOptions,
            inRange: cursor
        ) { result in
            if case let .success(response) = result {
                retrievedAnimalData = response
            }
        }

        PetFinderNetworker.session.capturedCompletionHandler?(sampleData, response200(), nil)
        XCTAssertNotNil(retrievedAnimalData, "retrievedAnimalData should not be nil")
    }

    func testCreatingRetrieveSingleAnimalTask() {
        PetFinderNetworker.retrieveAnimal(withIdentifier: 2) { _ in }

        guard let task = PetFinderNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a single animal should be get")
        XCTAssertEqual(request.url?.host, "api.petfinder.com", "The domain should be localhost")
        XCTAssertEqual(request.url?.path, "/pet.get", "The path should be /pet.get")
        XCTAssertTrue(
            request.url!.query!.contains("format=json"),
            "Query: \(request.url!.query!) should specify json format response"
        )
        XCTAssertTrue(
            request.url!.query!.contains("output=full"),
            "Query: \(request.url!.query!) should specify output size"
        )
        XCTAssertTrue(
            request.url!.query!.contains("id=2"),
            "Query: \(request.url!.query!) should contain animal id"
        )
        XCTAssertTrue(
            request.url!.query!.contains("key=APIKEY"),
            "Query: \(request.url!.query!) should contain api key"
        )

        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testHandlingRetrieveSingleAnimalNetworkFailure() {
        var receivedError: NSError?

        PetFinderNetworker.retrieveAnimal(withIdentifier: 2) { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError, "the network error should be passed to the completion handler")
    }

    func testHandlingMissingAnimalEndpoint() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Animal 1 not found",
                       "missing animal should provide an animal unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForSingleAnimal() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data",
                       "animal retrieval with missing data and success code should fail")
    }

    func testRetrievingSingleAnimal() {
        var retrievedAnimalData: PetFinderResponse?
        let sampleData = try! JSONSerialization.data(withJSONObject: [:], options: [])

        PetFinderNetworker.retrieveAnimal(withIdentifier: 1) { result in
            if case let .success(response) = result {
                retrievedAnimalData = response
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(sampleData, response200(), nil)
        XCTAssertNotNil(retrievedAnimalData, "retrievedAnimalData should not be nil")
    }
}

extension PetFinderNetworkerTests {

    func hasDataTask() -> Bool {
        var hasTasks = false

        PetFinderNetworker.session.getAllTasks { tasks in
            hasTasks = !tasks.isEmpty
        }
        return hasTasks
    }
}

enum TestError: Error {
    case error
}
