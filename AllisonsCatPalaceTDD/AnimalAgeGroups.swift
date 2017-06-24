//
//  AnimalAgeGroups.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalAgeGroup {
    case baby, young, adult, senior

    static private let petFinderRawValueMapping: [String: AnimalAgeGroup] = [
        "Baby": .baby,
        "Young": .young,
        "Adult": .adult,
        "Senior": .senior
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalAgeGroup.petFinderRawValueMapping[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}
