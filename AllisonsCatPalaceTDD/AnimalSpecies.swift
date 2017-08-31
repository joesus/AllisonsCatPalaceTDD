//
//  AnimalSpecies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum AnimalSpecies: Int {
    case cat, dog, other

    private static let petFinderRawValueMappable: [String: AnimalSpecies] = [
        "Cat": .cat,
        "Dog": .dog
    ]

    init(petFinderRawValue: String) {
        guard let value = AnimalSpecies.petFinderRawValueMappable[petFinderRawValue] else {
            self = .other
            return
        }
        self = value
    }
}

extension AnimalSpecies: Persistable {
    typealias ManagedObject = ManagedIntObject

    var managedObject: ManagedIntObject {
        let object = ManagedIntObject()

        object.value = self.rawValue

        return object
    }

    init?(managedObject: ManagedObject) {
        self.init(rawValue: managedObject.value)
    }
}
