//
//  CatDataSource.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class CatDataSource {

    @discardableResult
    static func fetchAllCats(completion: @escaping ([Cat]) -> Void) {
        CatNetworker.retrieveAllCats { result in
            switch result {
            case .success(let data):
                guard let cats = CatBuilder.buildCats(from: data) else {
                    return completion([])
                }
                completion(cats)
                break
            case .failure(_):
                return completion([])
            }
        }

    }

}
