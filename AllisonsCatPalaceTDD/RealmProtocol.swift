//
//  RealmProtocol.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/5/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

// This should be the protocol for the container
protocol RealmProtocol {
    func objects<T>(_ type: T.Type) -> Results<T>
}

extension Realm: RealmProtocol {}

struct InjectionMap {
    static var realm: RealmProtocol? = try? Realm()
}

protocol RealmInjected { }

extension RealmInjected {
    var realm: RealmProtocol? {
        return InjectionMap.realm
    }
}
