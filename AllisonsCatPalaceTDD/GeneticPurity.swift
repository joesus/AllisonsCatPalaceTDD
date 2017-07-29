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

    var isPurebred: Bool {
        return self == .purebred
    }
}
