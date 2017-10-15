//
//  AnimalSize.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalSizeObject: Object {
    dynamic var value: String? = nil
}

enum AnimalSize: String {

    case small, medium, large, extraLarge

    static private let petFinderRawValueMapping: [String: AnimalSize] = [
        "S": .small,
        "M": .medium,
        "L": .large,
        "XL": .extraLarge
    ]

    init?(petFinderRawValue: String) {
        guard let size = AnimalSize.petFinderRawValueMapping[petFinderRawValue] else {
            return nil
        }
        self = size
    }
}

extension AnimalSize: Persistable {
    typealias ManagedObject = AnimalSizeObject

    var managedObject: ManagedObject {
        let object = ManagedObject()

        object.value = self.rawValue

        return object
    }

    init?(managedObject: ManagedObject) {
        let value = managedObject.value
        guard let string = value else {

            return nil
        }

        self.init(rawValue: string)
    }
}
