//
//  AnimalGenotype.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias AnimalBreed = String

struct AnimalGenotype {

    let species: AnimalSpecies
    let purity: GeneticPurity
    let breeds: [AnimalBreed]

    init?(
        species: AnimalSpecies,
        purity: GeneticPurity,
        breeds: [AnimalBreed]
        ) {

        if purity == .purebred && breeds.count != 1 {
            return nil
        }

        self.species = species
        self.purity = purity
        self.breeds = breeds
    }
}
