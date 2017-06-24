//
//  AnimalSize.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalSize {

    case small, medium, large, extraLarge

    static private let petFinderRawValueMapping: [String: AnimalSize] = [
        "S": .small,
        "M": .medium,
        "L": .large,
        "XL": .extraLarge
    ]

    init?(petFinderRawValue: String) {
        guard let size = AnimalSize.petFinderRawValueMapping[petFinderRawValue] else {
            return nil
        }
        self = size
    }
}
