//
//  AnimalGenotype.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalGenotypeObject: Object {
    dynamic var species: AnimalSpeciesObject? = nil
    dynamic var purity: GeneticPurityObject? = nil
    var breeds = List<AnimalBreedObject>()
}

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

extension AnimalGenotype: Persistable {
    typealias ManagedObject = AnimalGenotypeObject

    var managedObject: ManagedObject {
        let object = ManagedObject()

        object.species = species.managedObject
        object.purity = purity.managedObject
        let managedBreeds = List<AnimalBreedObject>()

        breeds.forEach { breed in
            managedBreeds.append(breed.managedObject)
        }
        object.breeds = managedBreeds

        return object
    }

    init?(managedObject: ManagedObject) {
        guard let managedSpecies = managedObject.species,
            let species = AnimalSpecies(managedObject: managedSpecies),
            let managedPurity = managedObject.purity,
            let purity = GeneticPurity(managedObject: managedPurity) else {
            return nil
        }

        var breeds = [AnimalBreed]()
        managedObject.breeds.forEach { (breedObject) in
            if let breed = AnimalBreed(managedObject: breedObject) {
                breeds.append(breed)
            }
        }

        self.init(species: species, purity: purity, breeds: breeds)
    }
}
