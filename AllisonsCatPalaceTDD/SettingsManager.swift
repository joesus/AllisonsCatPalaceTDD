//
//  SettingsManager.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class SettingsManager {

    static let shared = SettingsManager()

    func set(value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func value(forKey key: Key) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }

    func clear() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }

        UserDefaults.standard.removePersistentDomain(forName: bundleId)
    }

    struct Key {
        var rawValue: String

        static let zipCode = Key(rawValue: "zipCode")
    }
}
