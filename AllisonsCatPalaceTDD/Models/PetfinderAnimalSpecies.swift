//
//  AnimalSpecies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class PetfinderAnimalSpeciesObject: Object {
    var value = RealmOptional<Int>()
}

protocol AnimalSpecies: CustomStringConvertible {}

enum PetfinderAnimalSpecies: Int, AnimalSpecies {

    case cat, dog, smallAndFurry, barnYard, bird, horse, rabbit, reptile

    private static let rawStrings = [
        "Cat",
        "Dog",
        "Small&amp;Furry",
        "BarnYard",
        "Bird",
        "Horse",
        "Rabbit",
        "Reptile"
    ]

    init?(petFinderRawValue: String) {
        guard let index = PetfinderAnimalSpecies.rawStrings.index(of: petFinderRawValue) else {
            return nil
        }

        self.init(rawValue: index)
    }

    var description: String {
        guard let rawString = PetfinderAnimalSpecies.rawStrings.element(at: rawValue) else {
            fatalError("Impossible species -- cannot exist")
        }

        return rawString
    }
}

extension PetfinderAnimalSpecies: Persistable {
    typealias ManagedObject = PetfinderAnimalSpeciesObject

    var managedObject: ManagedObject {
        let object = ManagedObject()

        object.value = RealmOptional<Int>(self.rawValue)

        return object
    }

    init?(managedObject: ManagedObject) {
        let value = managedObject.value
        guard let int = value.value else {

            return nil
        }

        self.init(rawValue: int)
    }
}
