//
//  AnimalImageLocations.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct AnimalImageLocations {
    let small: [URL]
    let medium: [URL]
    let large: [URL]

    init(
        small: [URL] = [],
        medium: [URL] = [],
        large: [URL] = []
        ) {

        self.small = small.removingDuplicates()
        self.medium = medium.removingDuplicates()
        self.large = large.removingDuplicates()
    }

}
