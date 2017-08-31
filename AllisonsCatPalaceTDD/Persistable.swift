//
//  Persistable.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/31/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: Object

    init(managedObject: ManagedObject)

    var managedObject: ManagedObject { get }
}
