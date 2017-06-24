//
//  AnimalPhotoSize.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalPhotoSize {
    case small, medium, large

    private static let petFinderRawValueMapping: [String: AnimalPhotoSize] = [
        "t": .small,
        "pn": .medium,
        "x": .large
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalPhotoSize.petFinderRawValueMapping[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}
