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
    cat.imageLocations = sampleImageLocations
    return cat
}

let sampleImageLocations = AnimalImageLocations(
    small: [URL(string: "https://www.google.com/cat.png")!],
    medium: [URL(string: "https://www.google.com/cat.png")!],
    large: [URL(string: "https://www.google.com/cat.png")!]
)

let sampleGenotype = AnimalGenotype(
    species: .cat,
    purity: .mixed,
    breeds: []
)

let sampleGenotypeWithBreeds = AnimalGenotype(
    species: .cat,
    purity: .purebred,
    breeds: [.calico]
)
