//
//  AnimalNetworkError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalNetworkError: Error {
    case missingAnimalService
    case missingAnimal(identifier: Int)
    case missingData

    var message: String {
        switch self {
        case .missingAnimal(identifier: let identifier):
            return "Animal \(identifier) not found"
        case .missingAnimalService:
            return "Animal service unavailable"
        case .missingData:
            return "Missing Data"
        }
    }
}
