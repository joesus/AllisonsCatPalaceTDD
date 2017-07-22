//
//  AnimalSex.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalSex {

    case male, female, unknown

    static private let petFinderRawValueMapping: [String: AnimalSex] = [
        "M": .male,
        "F": .female
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalSex.petFinderRawValueMapping[petFinderRawValue] else {
            self = .unknown
            return
        }
        self = value
    }
}
