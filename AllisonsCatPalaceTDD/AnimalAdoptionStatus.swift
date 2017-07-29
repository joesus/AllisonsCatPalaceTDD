//
//  AnimalAdoptionStatus.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalAdoptionStatus {
    case adoptable, onHold, pending

    init?(petFinderRawValue value: String) {
        switch value {
        case "A":
            self = .adoptable
        case "H":
            self = .onHold
        case "P":
            self = .pending
        default:
            return nil
        }
    }

    var isAdoptable: Bool {
        return self == .adoptable
    }
}
