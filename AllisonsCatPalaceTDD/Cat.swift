//
//  Cat.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class Cat {

    let name: String
    let identifier: Int
    var about: String? {
        didSet {
            guard let value = about,
                !value.isEmpty else {
                about = nil
                return
            }
        }
    }
    var isAdoptable = false
    var age: Int?
    var city: String? {
        didSet {
            guard let value = city,
                !value.isEmpty else {
                city = nil
                return
            }
        }
    }
    var cutenessLevel: Int? {
        didSet {
            guard let level = cutenessLevel,
                (1...11).contains(level) else {
                cutenessLevel = nil
                return
            }
        }
    }
    var favorites: [Favorite] = []
    var sex = AnimalSex.unknown
    var greeting: String? {
        didSet {
            guard let value = greeting,
                !value.isEmpty else {
                greeting = nil
                return
            }
        }
    }
    var stateCode: String? {
        didSet {
            guard let value = stateCode else { return }

            let range = NSRange(location: 0, length: value.characters.count)
            let regex = try? NSRegularExpression(pattern: "^[:alpha:]{2}$", options: [])
            guard let matches = regex?.matches(in: value, options: [], range: range),
                !matches.isEmpty else {
                stateCode = nil
                return
            }

            stateCode = value.uppercased()
        }
    }
    var weight: Int? {
        didSet {
            guard let value = weight,
                value > 0 else {
                    weight = nil
                    return
            }
        }
    }
    var imageLocations = AnimalImageLocations()

    init(name: String, identifier: Int, imageUrl: URL? = nil) {
        self.name = name
        self.identifier = identifier
    }
}
