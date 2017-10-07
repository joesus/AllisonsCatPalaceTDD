//
//  PaginationCursor.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/7/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct PaginationCursor {
    let size: Int
    let index: Int

    init(size: Int, index: Int = 0) {
        self.size = size
        self.index = index
    }

    var offset: Int {
        return size * index
    }
}
