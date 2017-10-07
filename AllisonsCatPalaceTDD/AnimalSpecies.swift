//
//  AnimalSpecies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalSpeciesObject: Object {
    var value = RealmOptional<Int>()
}

enum AnimalSpecies: Int {
    case cat, dog, smallAndFurry, barnYard, bird, horse, rabbit, reptile

    private static let petFinderRawValueMappable: [String: AnimalSpecies] = [
        "Cat": .cat,
        "Dog": .dog,
        "Small&amp;Furry": .smallAndFurry,
        "BarnYard": .barnYard,
        "Bird": .bird,
        "Horse": .horse,
        "Rabbit": .rabbit,
        "Reptile": .reptile
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalSpecies.petFinderRawValueMappable[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}

extension AnimalSpecies: Persistable {
    typealias ManagedObject = AnimalSpeciesObject

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
