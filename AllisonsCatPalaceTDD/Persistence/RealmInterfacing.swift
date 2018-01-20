//
//  RealmInterfacing.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/5/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

// This should be the protocol for the container
protocol RealmInterfacing {
    func objects<T>(_ type: T.Type) -> Results<T>
    func write(_ block: (() throws -> Void)) throws
    func delete(_ object: Object)
    func add(_ type: Object, update: Bool)
}

extension Realm: RealmInterfacing {}

struct InjectionMap {
    static var realm: RealmInterfacing? = try? Realm()
}

protocol RealmInjected { }

extension RealmInjected {
    var realm: RealmInterfacing? {
        return InjectionMap.realm
    }

}
