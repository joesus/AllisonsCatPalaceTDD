//
//  GeneticPurity.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum GeneticPurity {
    case purebred, mixed

    init?(petFinderRawValue: String) {
        switch petFinderRawValue {
        case "yes":
            self = .mixed
        case "no":
            self = .purebred
        default:
            return nil
        }
    }

    var isPurebred: Bool {
        return self == .purebred
    }
}
