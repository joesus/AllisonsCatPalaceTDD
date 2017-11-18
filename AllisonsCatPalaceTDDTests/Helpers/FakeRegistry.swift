//
//  FakeRegistry.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 11/5/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

class FakeRegistry: AnimalFinding {
    static var stubbedAnimals = [Animal]()
    static var findAnimalsCallCount = 0
    static var capturedSearchParameters: PetFinderSearchParameters?
    static var capturedPaginationCursor: PaginationCursor?
    private static var capturedCompletionHandler: (([Animal]) -> Void)?
    static var offset: Int = 0

    static func findAnimals(
        matching searchParameters: PetFinderSearchParameters,
        cursor: PaginationCursor,
        completion: @escaping ([Animal]) -> Void
        ) {

        findAnimalsCallCount += 1
        capturedSearchParameters = searchParameters
        capturedPaginationCursor = cursor
        capturedCompletionHandler = completion
    }
    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void) {
        completion(stubbedAnimals.first)
    }

    static func reset() {
        stubbedAnimals = [Animal]()
        findAnimalsCallCount = 0
        capturedSearchParameters = nil
        capturedPaginationCursor = nil
        capturedCompletionHandler = nil
    }

    static func invokeCompletionHandler(with animals: [Animal]) {
        capturedCompletionHandler?(animals)
    }
}
