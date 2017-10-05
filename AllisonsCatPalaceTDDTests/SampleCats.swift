//
//  SampleCats.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

let SampleCat = Animal(name: "SampleCat", identifier: 1)

let cats: [Animal] = (1...100).map { integer in
    let cat = Animal(name: "test", identifier: integer)
    cat.imageLocations = SampleImageLocations.smallMediumLarge
    return cat
}

let sampleGenotype = AnimalGenotype(
    species: .cat,
    purity: .mixed,
    breeds: []
)

enum SampleImageLocations {
    static let smallMediumLarge = AnimalImageLocations(
        small: [URL(string: "https://www.google.com/small-cat.png")!],
        medium: [URL(string: "https://www.google.com/medium-cat.png")!],
        large: [URL(string: "https://www.google.com/large-cat.png")!]
    )

    static let smallAndLargeOnly = AnimalImageLocations(
        small: [URL(string: "https://www.google.com/catSmall.png")!, URL(string: "https://www.google.com/catSmall2.png")!],
        medium: [],
        large: [URL(string: "https://www.google.com/catLarge.png")!]
    )

    static let largeOnly = AnimalImageLocations(
        small: [],
        medium: [],
        large: [URL(string: "https://www.google.com/catLarge.png")!, URL(string: "https://www.google.com/catLarge2.png")!]
    )
}
