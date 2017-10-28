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

enum SampleGenotypes {
    static let breeds = ["terrier", "Lab", "CALICO"]

    static let mixedCatNoBreeds = AnimalGenotype(
        species: .cat,
        purity: .mixed,
        breeds: []
    )

    static let mixedCatSingleBreed = AnimalGenotype(
        species: .cat,
        purity: .mixed,
        breeds: ["Cat Breed"]
    )

    static let mixedCatMultipleBreeds = AnimalGenotype(
        species: .cat,
        purity: .mixed,
        breeds: breeds
    )

    static let purebredCatNoBreeds = AnimalGenotype(
        species: .cat,
        purity: .purebred,
        breeds: []
    )

    static let purebredCatSingleBreed = AnimalGenotype(
        species: .cat,
        purity: .purebred,
        breeds: ["Cat breed"]
    )

    static let purebredCatMultipleBreeds = AnimalGenotype(
        species: .cat,
        purity: .purebred,
        breeds: breeds
    )
}

enum SampleImageLocations {
    static let noImages = AnimalImageLocations(
        small: [],
        medium: [],
        large: []
    )

    static let multipleSmall = AnimalImageLocations(
        small: [
            URL(string: "https://www.google.com/test.png")!,
            URL(string: "https://www.google.com/test2.png")!
        ],
        medium: [],
        large: []
    )

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
