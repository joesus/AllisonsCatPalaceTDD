//
//  AnimalRegistry
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

protocol AnimalFetching: class {
    static var offset: Int { get set }
    static func fetchAllAnimals(completion: @escaping ([Animal]) -> Void)
    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void)
}

class AnimalRegistry: AnimalFetching {
    static var offset = 0

    static func fetchAllAnimals(completion: @escaping ([Animal]) -> Void) {
        PetFinderNetworker.retrieveAllAnimals(offset: offset) { result in
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
