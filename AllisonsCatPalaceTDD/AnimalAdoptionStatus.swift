//
//  AnimalAdoptionStatus.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalAdoptionStatusObject: Object {
    var value = RealmOptional<Int>()
}

enum AnimalAdoptionStatus: Int {
    case adoptable, onHold, pending

    init?(petFinderRawValue value: String) {
        switch value {
        case "A":
            self = .adoptable
        case "H":
            self = .onHold
        case "P":
            self = .pending
        default:
            return nil
        }
    }

    var isAdoptable: Bool {
        return self == .adoptable
    }
}

extension AnimalAdoptionStatus: Persistable {
    typealias ManagedObject = AnimalAdoptionStatusObject

    var managedObject: ManagedObject {
        let object = AnimalAdoptionStatusObject()

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
