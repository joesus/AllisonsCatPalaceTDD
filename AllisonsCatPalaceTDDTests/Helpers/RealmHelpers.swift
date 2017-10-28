//
//  RealmHelpers.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 9/1/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift

extension XCTestCase {
    func realmForTest(withName name: String) -> Realm {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name

        return try! Realm()
    }

    func reset(_ realm: Realm) {
        try? realm.write {
            realm.deleteAll()
        }
    }
}
