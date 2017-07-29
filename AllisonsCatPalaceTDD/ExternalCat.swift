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
    static let contact = "contact"
    static let media = "media"
    static let photos = "photos"
    static let photo = "photo"
    static let photoSize = "@size"
    static let elementContentKey = "$t"
    static let id = "id"
    static let about = "description"
    static let age = "age"
    static let adoptionStatus = "status"
    static let city = "city"
    static let favorites = "favorites"
    static let sex = "sex"
    static let size = "size"
    static let state = "state"
}
