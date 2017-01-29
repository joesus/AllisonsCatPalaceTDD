//
//  Box.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct Box<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    func unbox() -> T {
        return value
    }
}
