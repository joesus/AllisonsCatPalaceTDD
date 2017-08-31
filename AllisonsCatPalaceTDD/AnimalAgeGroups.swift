//
//  AnimalAgeGroups.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

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
