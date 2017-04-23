//
//  ExternalCatData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

struct ExternalCatData {
    typealias JSON = [String: Any]
    static let valid: JSON = [ExternalCatKeys.name: "CatOne",
                                       ExternalCatKeys.id: 1]
    static let anotherValid: JSON = [ExternalCatKeys.name: "CatTwo",
                                              ExternalCatKeys.id: 2]
    static let withURLString: JSON = [ExternalCatKeys.name: "Cat",
                                               ExternalCatKeys.id: 3,
                                               ExternalCatKeys.pictureURL: "https://example.com/foo.gif"]
    static let withBadURLString: JSON = [ExternalCatKeys.name: "Cat",
                                                  ExternalCatKeys.id: 4,
                                                  ExternalCatKeys.pictureURL: "blah blah"]
    static let missingIdentifier: JSON = [ExternalCatKeys.name: "CatOne"]
    static let missingName: JSON = [ExternalCatKeys.id: 1]
    static let invalid: JSON = [:]
    static let female: JSON = [ExternalCatKeys.name: "CatTwo",
                                        ExternalCatKeys.id: 2,
                                        ExternalCatKeys.gender: "female"]
    static let male: JSON = [ExternalCatKeys.name: "CatTwo",
                                      ExternalCatKeys.id: 2,
                                      ExternalCatKeys.gender: "male"]
    static let neutered: JSON = [ExternalCatKeys.name: "CatTwo",
                                          ExternalCatKeys.id: 2,
                                          ExternalCatKeys.gender: 1800]
    static let full = [
        ExternalCatKeys.about: "I am a cat",
        ExternalCatKeys.adoptable: true,
        ExternalCatKeys.age: 10,
        ExternalCatKeys.city: "Denver",
        ExternalCatKeys.cutenessLevel: 3,
        ExternalCatKeys.favorites: [
            [
                "category": "hat",
                "value": "cowboy baby"
            ]
        ],
        ExternalCatKeys.gender: "male",
        ExternalCatKeys.greeting: "Meooooow",
        ExternalCatKeys.id: 2,
        ExternalCatKeys.name: "testCat",
        ExternalCatKeys.pictureURL: "https://placebear.com/200/300",
        ExternalCatKeys.state: "CO",
        ExternalCatKeys.weight: 10
        ] as JSON
}
