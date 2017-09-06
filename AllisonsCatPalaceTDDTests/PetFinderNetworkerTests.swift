//
//  PetFinderNetworkerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class PetFinderNetworkerTests: XCTestCase {

    var taskRetrievalExpectation: XCTestExpectation!

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
        XCTAssertEqual(PetFinderNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllAnimalsTask() {
        PetFinderNetworker.retrieveAllAnimals {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving cats should be get")
        XCTAssertEqual(request.url?.host, "api.petfinder.com", "The domain should be localhost")
        XCTAssertEqual(request.url?.path, "/pet.find", "The path should be cats")
        XCTAssertTrue(request.url!.query!.contains("format=json"), "Query: \(request.url!.query!) should specify json format response")
        XCTAssertTrue(request.url!.query!.contains("output=full"), "Query: \(request.url!.query!) should specify output size")
        XCTAssertTrue(request.url!.query!.contains("location="), "Query: \(request.url!.query!) should specify location")
        XCTAssertTrue(request.url!.query!.contains("key=APIKEY"), "Query: \(request.url!.query!) should contain api key")

        XCTAssertTrue(request.url!.query!.contains("count=\(PetFinderNetworker.desiredNumberOfResults)"), "Query: \(request.url!.query!) should contain predefined default results count")
        XCTAssertTrue(request.url!.query!.contains("offset=0"), "Query: \(request.url!.query!) should contain default offset of zero")
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testCreatingRetrieveAllAnimalsTaskWithPersistedLocation() {
        SettingsManager.shared.set(value: "55555", forKey: .zipCode)
        PetFinderNetworker.retrieveAllAnimals {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest else {

            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertTrue(request.url!.query!.contains("55555"), "Query: \(request.url!.query!) should use the persisted location")
    }

    func testCreatingRetrieveAllAnimalsTaskWithPersistedLocationDoesNotDuplicateLocationParam() {
        SettingsManager.shared.set(value: "55555", forKey: .zipCode)
        PetFinderNetworker.retrieveAllAnimals {_ in}

        SettingsManager.shared.set(value: "88888", forKey: .zipCode)
        PetFinderNetworker.retrieveAllAnimals {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest else {

                return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.url!.query!.components(separatedBy: "location=").count - 1, 1,
                       "Creating a new task with a new persisted zip code should not add duplicate zip codes to query")
    }

    func testCreatingRetrieveAllAnimalsTaskWithOffset() {
        PetFinderNetworker.retrieveAllAnimals(offset: 25) {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertTrue(request.url!.query!.contains("offset=25"), "Query: \(request.url!.query!) should use the given offset")
    }

    func testCreatingRetrieveAllAnimalsTaskWithOffsetDoesNotDuplicateOffsetParam() {
        PetFinderNetworker.retrieveAllAnimals {_ in}
        PetFinderNetworker.retrieveAllAnimals(offset: 50) {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest else {

                return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.url!.query!.components(separatedBy: "offset=").count - 1, 1,
                       "Creating a new task with a different offset should not add duplicate offset to query")
    }

    func testCreatingRetrieveAllAnimalsTaskWithNoStoredSpecies() {
        PetFinderNetworker.retrieveAllAnimals {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest else {
                return XCTFail("A task should have a currentRequest")
        }

        XCTAssertFalse(request.url!.query!.contains("animal="), "Query: \(request.url!.query!) should not include a species when there is no stored species")
    }

    func testCreatingRetrieveAllAnimalsTaskWithSpecies() {
        SettingsManager.shared.set(value: AnimalSpecies.dog.rawValue, forKey: .species)
        PetFinderNetworker.retrieveAllAnimals(offset: 25) {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertTrue(request.url!.query!.contains("animal=dog"), "Query: \(request.url!.query!) should use the stored species")
    }

    func testCreatingRetrieveAllAnimalsTaskWithSpeciesDoesNotDuplicateSpeciesParam() {
        SettingsManager.shared.set(value: AnimalSpecies.dog.rawValue, forKey: .species)

        PetFinderNetworker.retrieveAllAnimals {_ in}
        PetFinderNetworker.retrieveAllAnimals {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask,
            let request = task.currentRequest else {

                return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.url!.query!.components(separatedBy: "animal=").count - 1, 1,
                       "Creating a new task with a persisted species should not add duplicate species param to query")
    }

    func testNewRetrieveAllAnimalsTaskCancelsExistingTask() {
        PetFinderNetworker.retrieveAllAnimals { _ in }

        guard let firstTask = PetFinderNetworker.session.lastResumedDataTask else {
            fatalError("A task should have been created")
        }
        PetFinderNetworker.retrieveAllAnimals { _ in }
        XCTAssertTrue(firstTask.cancelWasCalled, "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }

    func testHandlingRetrieveAllAnimalsNetworkFailure() {
        var receivedError: NSError?

        PetFinderNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as NSError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertEqual(receivedError, fakeNetworkError, "the network error should be passed to the completion handler")
    }

    func testHandlingMissingAnimalsEndpoint() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertEqual(receivedError?.message, "Animal service unavailable", "missing animal endpoint should provide a service unavailable message")
    }

    func testHandlingMissingDataWithValidResponseForAllAnimals() {
        var receivedError: AnimalNetworkError?

        PetFinderNetworker.retrieveAllAnimals { result in
            if case let .failure(error) = result {
                receivedError = error as? AnimalNetworkError
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)
        XCTAssertEqual(receivedError?.message, "Missing Data", "animal retrieval with missing data and success code should fail")
    }

    func testRetrievingAllAnimals() {
        var retrievedAnimalData: PetFinderResponse?
        let sampleData = try! JSONSerialization.data(withJSONObject: [:], options: [])

        PetFinderNetworker.retrieveAllAnimals { result in
            if case let .success(response) = result {
                retrievedAnimalData = response
            }
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(sampleData, response200(), nil)
        XCTAssertNotNil(retrievedAnimalData, "retrievedAnimalData should not be nil")
    }

    func testCreatingRetrieveSingleAnimalTask() {
        PetFinderNetworker.retrieveAnimal(withIdentifier: 2) {_ in}

        guard let task = PetFinderNetworker.session.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a single animal should be get")
        XCTAssertEqual(request.url?.host, "api.petfinder.com", "The domain should be localhost")
        XCTAssertEqual(request.url?.path, "/pet.get", "The path should be /pet.get")
        XCTAssertTrue(request.url!.query!.contains("format=json"), "Query: \(request.url!.query!) should specify json format response")
        XCTAssertTrue(request.url!.query!.contains("output=full"), "Query: \(request.url!.query!) should specify output size")
        XCTAssertTrue(request.url!.query!.contains("id=2"), "Query: \(request.url!.query!) should contain animal id")
        XCTAssertTrue(request.url!.query!.contains("key=APIKEY"), "Query: \(request.url!.query!) should contain api key")

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
        XCTAssertEqual(receivedError?.message, "Animal 1 not found", "missing animal should provide an animal unavailable message")
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
        XCTAssertEqual(receivedError?.message, "Missing Data", "animal retrieval with missing data and success code should fail")
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
