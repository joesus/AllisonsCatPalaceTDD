//
//  AnimalType.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalType {
    case cat, dog

    private static let petFinderRawValueMappable: [String: AnimalType] = [
        "Cat": .cat,
        "Dog": .dog
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalType.petFinderRawValueMappable[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}
