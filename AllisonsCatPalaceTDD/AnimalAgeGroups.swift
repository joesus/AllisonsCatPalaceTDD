//
//  AnimalAgeGroups.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalAgeGroupObject: Object {
    var value = RealmOptional<Int>()
}

enum AnimalAgeGroup: Int {
    case baby, young, adult, senior

    static private let petFinderRawValueMapping: [String: AnimalAgeGroup] = [
        "Baby": .baby,
        "Young": .young,
        "Adult": .adult,
        "Senior": .senior
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalAgeGroup.petFinderRawValueMapping[petFinderRawValue] else {
            return nil
        }
        self = value
    }
}

extension AnimalAgeGroup: Persistable {
    typealias ManagedObject = AnimalAgeGroupObject

    var managedObject: ManagedObject {
        let object = AnimalAgeGroupObject()

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
