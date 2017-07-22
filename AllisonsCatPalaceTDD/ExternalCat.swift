//
//  ExternalCat.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias ExternalCat = [String: Any]
typealias ExternalCatList = [ExternalCat]

enum ExternalCatKeys {
    static let name = "name"
    static let id = "id"
    static let pictureURL = "pictureurl"
    static let about = "about"
    static let age = "age"
    static let adoptable = "adoptable"
    static let city = "city"
    static let favorites = "favorites"
    static let sex = "sex"
    static let state = "state"
    static let weight = "weight"
}
