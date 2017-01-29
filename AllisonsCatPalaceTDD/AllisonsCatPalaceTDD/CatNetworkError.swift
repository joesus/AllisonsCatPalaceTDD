//
//  CatNetworkError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum CatNetworkError: Error {
    case missingCatService
    case missingCat(identifier: Int)
    case missingData

    var message: String {
        switch self {
        case .missingCat(identifier: let identifier):
            return "Cat \(identifier) not found"
        case .missingCatService:
            return "Cat service unavailable"
        case .missingData:
            return "Missing Data"
        }
    }
}
