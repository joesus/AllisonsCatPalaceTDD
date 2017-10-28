//
//  GeneticPurity.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class GeneticPurityObject: Object {
    var value = RealmOptional<Int>()
}

enum GeneticPurity: Int {
    case purebred, mixed

    init?(petFinderRawValue: String) {
        switch petFinderRawValue {
        case "yes":
            self = .mixed
        case "no":
            self = .purebred
        default:
            return nil
        }
    }

    var isPurebred: Bool {
        return self == .purebred
    }
}

extension GeneticPurity: Persistable {
    typealias ManagedObject = GeneticPurityObject

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
