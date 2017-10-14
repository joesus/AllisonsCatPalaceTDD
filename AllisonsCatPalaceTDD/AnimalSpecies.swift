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
    dynamic var value: String? = nil
}

enum AnimalSpecies: String {
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

        object.value = self.rawValue

        return object
    }

    init?(managedObject: ManagedObject) {
        guard let value = managedObject.value else {
            return nil
        }

        self.init(rawValue: value)
    }
}
