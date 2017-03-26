//
//  ExternalCatData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

// TODO:- Add another enum for key constants that matches prod

struct ExternalCatData {
    static let valid: [String: Any] = ["name": "CatOne", "id": 1]
    static let anotherValid: [String: Any] = ["name": "CatTwo", "id": 2]
    static let withURLString: [String: Any] = ["name": "Cat", "id": 3, "pictureurl": "https://example.com/foo.gif"]
    static let withBadURLString: [String: Any] = ["name": "Cat", "id": 4, "pictureurl": "blah blah"]
    static let missingIdentifier: [String: Any] = ["name": "CatOne"]
    static let missingName: [String: Any] = ["id": 1]
    static let invalid: [String: Any] = [:]
    static let female: [String: Any] = ["name": "CatTwo", "id": 2, "gender": "female"]
    static let male: [String: Any] = ["name": "CatTwo", "id": 2, "gender": "male"]
    static let neutered: [String: Any] = ["name": "CatTwo", "id": 2, "gender": 1800]
    static let full = [
        "about": "I am a cat",
        "adoptable": true,
        "age": 10,
        "city": "Denver",
        "cutenesslevel": 3,
        "favorites": [
            [
                "category": "hat",
                "value": "cowboy baby"
            ]
        ],
        "gender": "male",
        "greeting": "Meooooow",
        "id": 2,
        "name": "testCat",
        "pictureurl": "https://placebear.com/200/300",
        "state": "CO",
        "weight": 10
        ] as [String : Any]

}
