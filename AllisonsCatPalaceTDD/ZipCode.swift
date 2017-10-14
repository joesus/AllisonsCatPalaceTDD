//
//  ZipCode.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct ZipCode: RawRepresentable, Equatable {
    let rawValue: String

    init?(rawValue: String) {
        guard rawValue.characters.count == 5,
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: rawValue))
            else {
                return nil
        }

        self.rawValue = rawValue
    }
}
