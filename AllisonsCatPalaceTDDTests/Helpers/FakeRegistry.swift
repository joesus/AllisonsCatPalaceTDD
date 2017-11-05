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
    static var animals = [Animal]()
    static var fetchAllAnimalsCallCount = 0
    static var offset: Int = 0

    static func findAnimals(
        matching: PetFinderSearchParameters,
        cursor: PaginationCursor,
        completion: @escaping ([Animal]) -> Void
        ) {

        fetchAllAnimalsCallCount += 1
        completion(animals)
    }
    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void) {
        completion(animals.first)
    }

    static func reset() {
        animals = [Animal]()
        fetchAllAnimalsCallCount = 0
    }
}
