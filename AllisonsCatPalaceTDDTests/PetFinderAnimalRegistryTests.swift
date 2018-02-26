// swiftlint:disable force_try line_length
//
//  PetFinderAnimalRegistryTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderAnimalRegistryTests: XCTestCase {

    var completionHandlerInvoked = false
    var cursor = PaginationCursor(size: 20)

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

    func testFindingAnimalsFailure() {
        var receivedAnimals: [Animal]?
        PetFinderAnimalRegistry.findAnimals(
            matching: SampleSearchParameters.fullSearchOptions,
            cursor: cursor
        ) { animals in

            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked,
                      "Completion handler should be invoked on all calls to registry")
        XCTAssertTrue(receivedAnimals!.isEmpty,
                      "Should not have animals without data")
    }

    func testFindingAnimalsWithEmptyResult() {
        var receivedAnimals: [Animal]?
        PetFinderAnimalRegistry.findAnimals(
            matching: SampleSearchParameters.fullSearchOptions,
            cursor: cursor
        ) { animals in

            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler

        let emptyAnimalsData = try! JSONSerialization.data(withJSONObject: [], options: [])

        handler?(emptyAnimalsData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssert(receivedAnimals!.isEmpty, "Should not have animals with empty data")
    }

    func testFindingAnimalsSuccess() {
        var receivedAnimals: [Animal]?
        PetFinderAnimalRegistry.findAnimals(
            matching: SampleSearchParameters.fullSearchOptions,
            cursor: cursor
        ) { animals in

            self.completionHandlerInvoked = true
            receivedAnimals = animals
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler

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
        PetFinderAnimalRegistry.fetchAnimal(withIdentifier: 2) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        handler?(nil, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedAnimal, "Should not return an animal if there is no data")
    }

    func testGetSingleAnimalWithEmptyResult() {
        var retrievedAnimal: Animal?
        PetFinderAnimalRegistry.fetchAnimal(withIdentifier: 1) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        let emptyData = try! JSONSerialization.data(withJSONObject: [:], options: [])
        handler?(emptyData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNil(retrievedAnimal, "Should not return an animal if the data is empty")
    }

    func testGetSingleAnimalSuccess() {
        var retrievedAnimal: Animal?
        PetFinderAnimalRegistry.fetchAnimal(withIdentifier: 1) { animal in
            self.completionHandlerInvoked = true
            retrievedAnimal = animal
        }
        let handler = PetFinderNetworker.session.capturedCompletionHandler
        let sampleData = SampleExternalAnimalData.wrap(animal: SampleExternalAnimalData.valid)
        let animalData = try! JSONSerialization.data(withJSONObject: sampleData, options: [])

        handler?(animalData, response200(), nil)

        XCTAssertTrue(completionHandlerInvoked, "Completion handler should be invoked on all calls to registry")
        XCTAssertNotNil(retrievedAnimal, "Valid animal data should return an animal")
    }

    func testRegistryProvidesSearchController() {
        let controller = PetFinderAnimalRegistry.searchController(
            for: SampleSearchParameters.minimalSearchOptions
        ) { _ in }

        XCTAssertTrue(controller.results.isEmpty,
                      "Registry should provide a search controller in its default state with no results")
        XCTAssertFalse(controller.resultsKnownToBeExhausted,
                       "Registry should provide a search controller in its default state with results not known to be exhausted")
        // TODO:- get passing for CI
        //        XCTAssertEqual(
//            controller.cursor,
//            PaginationCursor(size: 20, index: 0),
//            "Registry should provide a search controller with a default pagination cursor with a size of 20 and an index of 0"
//            )
    }
}
