//
//  AnimalAdoptionStatus.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class ManagedIntObject: Object {
    dynamic var value: Int = 0 // Need to make sure this is safe to do
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
