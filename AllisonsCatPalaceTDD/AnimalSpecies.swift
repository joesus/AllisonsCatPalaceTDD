//
//  AnimalSpecies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalSpecies {
    case cat, dog

    private static let petFinderRawValueMappable: [String: AnimalSpecies] = [
        "Cat": .cat,
        "Dog": .dog
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalSpecies.petFinderRawValueMappable[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}
