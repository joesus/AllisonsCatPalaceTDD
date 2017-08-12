//
//  AnimalRegistryTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalRegistryTests: XCTestCase {

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

    func testGettingAllAnimalsFailure() {
        var receivedAnimals: [Animal]?
        AnimalRegistry.fetchAllAnimals() { animals in
            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssert(receivedAnimals!.isEmpty, "Should not have animals without data")
    }

    func testGettingAllAnimalsWithEmptyResult() {
        var receivedAnimals: [Animal]?
        AnimalRegistry.fetchAllAnimals() { animals in
            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler

        let emptyAnimalsData = try! JSONSerialization.data(withJSONObject: [], options: [])

        handler?(emptyAnimalsData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssert(receivedAnimals!.isEmpty, "Should not have animals with empty data")
    }

    func testGettingAllAnimalsSuccess() {
        var receivedAnimals: [Animal]?
        AnimalRegistry.fetchAllAnimals() { animals in
            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler

        let sampleData = SampleExternalAnimalData.wrap(animals: [
            SampleExternalAnimalData.valid,
            SampleExternalAnimalData.anotherValid])
        let animalData = try! JSONSerialization.data(withJSONObject: sampleData, options: [])

        handler?(animalData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertEqual(receivedAnimals!.count, 2, "Should have received two animals")
    }

    func testGetSingleAnimalFailure() {
        var retrievedAnimal: Animal?
        AnimalRegistry.fetchAnimal(withIdentifier: 2) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedAnimal, "Should not return an animal if there is no data")
    }

    func testGetSingleAnimalWithEmptyResult() {
        var retrievedAnimal: Animal?
        AnimalRegistry.fetchAnimal(withIdentifier: 1) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        let emptyData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        handler?(emptyData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedAnimal, "Should not return an animal if the data is empty")
    }

    func testGetSingleAnimalSuccess() {
        var retrievedAnimal: Animal?
        AnimalRegistry.fetchAnimal(withIdentifier: 1) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = AnimalNetworker.session.capturedCompletionHandler
        let sampleData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.valid)
        let animalData = try! JSONSerialization.data(withJSONObject: sampleData, options: [])

        handler?(animalData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNotNil(retrievedAnimal, "Valid animal data should return an animal")
    }
}
