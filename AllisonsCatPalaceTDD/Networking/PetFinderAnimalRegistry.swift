//
//  PetFinderAnimalRegistry
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

protocol AnimalFinding {
    static var offset: Int { get set }
    static func findAnimals(
        matching: PetFinderSearchParameters,
        cursor: PaginationCursor,
        completion: @escaping ([Animal]) -> Void
    )
    static func fetchAnimal(
        withIdentifier: Int,
        completion: @escaping (Animal?) -> Void
    )
}

enum PetFinderAnimalRegistry: AnimalFinding {
    static var offset = 0
    private static let animalSearchPageSize = 20

    static func searchController(
        for criteria: PetFinderSearchParameters,
        resultsHandler: @escaping ([Int]) -> Void
        ) -> PetFinderSearchController {

            return PetFinderSearchController(
                with: criteria,
                pageSize: animalSearchPageSize,
                finderProxy: self,
                completion: resultsHandler
        )
    }

    static func findAnimals(
        matching criteria: PetFinderSearchParameters,
        cursor: PaginationCursor,
        completion: @escaping ([Animal]) -> Void
        ) {

        PetFinderNetworker.findAnimals(
            matching: criteria,
            inRange: cursor
        ) { result in

            guard case .success(let response) = result else {
                return completion([])
            }

            completion(PetFinderAnimalBuilder.buildAnimals(from: response))
        }
    }

    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void) {
        PetFinderNetworker.retrieveAnimal(withIdentifier: identifier) { result in
            guard case .success(let response) = result else {
                return completion(nil)
            }

            completion(PetFinderAnimalBuilder.buildAnimal(from: response))
        }
    }
}
