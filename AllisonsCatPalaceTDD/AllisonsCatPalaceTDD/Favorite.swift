//
//  Favorite.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct Favorite {

    let identifier: Int
    let category: String
    let value: String

    init?(identifier: Int, category: String, value: String) {
        guard !category.isEmpty,
            !value.isEmpty else {
                return nil
        }
        self.identifier = identifier
        self.category = category
        self.value = value
    }
}
