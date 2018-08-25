//
//  AnimalGenotype.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

typealias AnimalBreed = String

class AnimalGenotypeObject: Object {
    dynamic var species: PetfinderAnimalSpeciesObject?
    dynamic var purity: GeneticPurityObject?
    dynamic var breeds = Data()
}

struct AnimalGenotype {

    let species: PetfinderAnimalSpecies
    let purity: GeneticPurity
    let breeds: [AnimalBreed]

    init?(
        species: PetfinderAnimalSpecies,
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
        object.breeds = NSKeyedArchiver.archivedData(withRootObject: breeds)

        return object
    }

    init?(managedObject: ManagedObject) {
        guard let managedSpecies = managedObject.species,
            let species = PetfinderAnimalSpecies(managedObject: managedSpecies),
            let managedPurity = managedObject.purity,
            let purity = GeneticPurity(managedObject: managedPurity) else {
            return nil
        }

        let breeds = NSKeyedUnarchiver.unarchiveObject(with: managedObject.breeds) as? [String] ?? []

        self.init(species: species, purity: purity, breeds: breeds)
    }
}
