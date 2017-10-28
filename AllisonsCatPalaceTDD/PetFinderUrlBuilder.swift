//
//  PetFinderUrlBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum PetFinderUrlBuilder {

    enum PaginationKeys {
        static let offset = "offset"
        static let count = "count"
    }
}

extension PaginationCursor {
    var petFinderUrlQueryItems: Set<URLQueryItem> {
        return [
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.offset,
                value: String(offset)
            ),
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.count,
                value: String(size)
            )
        ]
    }
}
