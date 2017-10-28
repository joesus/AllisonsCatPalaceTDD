//
//  PositiveInteger.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct PositiveInteger {
    let value: Int

    init?(_ value: Int) {
        guard value > 0 else { return nil }

        self.value = value
    }
}
