//
//  AnimalSex.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalSexObject: Object {
    dynamic var value: String? = nil
}

enum AnimalSex: String {

    case male, female, unknown

    static private let petFinderRawValueMapping: [String: AnimalSex] = [
        "M": .male,
        "F": .female
    ]

    init?(petFinderRawValue: String) {
        guard let value = AnimalSex.petFinderRawValueMapping[petFinderRawValue] else {
            self = .unknown
            return
        }
        self = value
    }
}

extension AnimalSex: Persistable {
    typealias ManagedObject = AnimalSexObject

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
