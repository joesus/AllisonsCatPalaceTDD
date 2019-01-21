//
//  AnimalAgeGroups.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalAgeGroupObject: Object {
    @objc dynamic var value: String?
}

enum AnimalAgeGroup: String {
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

        object.value = self.rawValue

        return object
    }

    init?(managedObject: ManagedObject) {
        guard let int = managedObject.value else {
            return nil
        }

        self.init(rawValue: int)
    }
}
