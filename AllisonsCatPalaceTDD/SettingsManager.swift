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

    func set(value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
