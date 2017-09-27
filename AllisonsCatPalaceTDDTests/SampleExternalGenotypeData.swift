//
//  SampleExternalGenotypeData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

typealias ExternalGenotype = JsonObject

struct SampleExternalGenotypeData {
    static let catSpecies: JsonObject = [
        "$t": "Cat"
    ]
    static let mixed: JsonObject = [
        "$t": "yes"
    ]
    static let purebred: JsonObject = [
        "$t": "no"
    ]
    static let validBreed: JsonObject = [
        "breed": [
            [
                "$t": "Domestic Short Hair-black and white"
            ]
        ]
    ]
    static let validBreeds: JsonObject = [
        "breed": [
            [
                "$t": "Domestic Short Hair-black and white"
            ],
            [
                "$t": "Tabby - Orange"
            ]
        ]
    ]
    static let validMixed: ExternalGenotype = [
        "animal": catSpecies,
        "mix": mixed,
        "breeds": validBreeds
    ]
    static let validPurebred: ExternalGenotype = [
        "animal": catSpecies,
        "mix": purebred,
        "breeds": validBreed
    ]
    static let missingSpecies: ExternalGenotype = [
        "mix": mixed,
        "breeds": validBreeds
    ]
    static let emptySpecies: ExternalGenotype = [
        "animal": [],
        "mix": mixed,
        "breeds": validBreeds
    ]
    static let missingPurity: ExternalGenotype = [
        "animal": catSpecies,
        "breeds": validBreeds
    ]
    static let emptyPurity: ExternalGenotype = [
        "animal": catSpecies,
        "mix": [],
        "breeds": validBreeds
    ]
    static let missingBreedsElement: ExternalGenotype = [
        "animal": catSpecies,
        "mix": mixed
    ]
    static let missingBreedElement: ExternalGenotype = [
        "animal": catSpecies,
        "mix": mixed,
        "breeds": []
    ]
    static let emptyBreedElement: ExternalGenotype = [
        "animal": catSpecies,
        "mix": mixed,
        "breeds": [
            "breed": []
        ]
    ]
}
