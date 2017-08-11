//
//  AnimalRegistry
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class AnimalRegistry {

    static func fetchAllAnimals(completion: @escaping ([Animal]) -> Void) {
        AnimalNetworker.retrieveAllAnimals { result in
            switch result {
            case .success(let data):
                completion(AnimalBuilder.buildAnimals(from: data))
            case .failure(_):
                completion([])
            }
        }
    }

    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void) {
        AnimalNetworker.retrieveAnimal(withIdentifier: identifier) { result in
            switch result {
            case .success(let data):
                completion(AnimalBuilder.buildAnimal(from: data))
            case .failure(_):
                completion(nil)
            }
        }
    }
}
