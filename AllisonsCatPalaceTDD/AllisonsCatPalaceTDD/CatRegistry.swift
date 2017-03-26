//
//  CatRegistry.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class CatRegistry {

    static func fetchAllCats(completion: @escaping ([Cat]) -> Void) {
        CatNetworker.retrieveAllCats { result in
            switch result {
            case .success(let data):
                completion(CatBuilder.buildCats(from: data))
            case .failure(_):
                completion([])
            }
        }
    }

    static func fetchCat(withIdentifier identifier: Int, completion: @escaping (Cat?) -> Void) {
        CatNetworker.retrieveCat(withIdentifier: identifier) { result in
            switch result {
            case .success(let data):
                completion(CatBuilder.buildCat(from: data))
            case .failure(_):
                completion(nil)
            }
        }
    }
}
