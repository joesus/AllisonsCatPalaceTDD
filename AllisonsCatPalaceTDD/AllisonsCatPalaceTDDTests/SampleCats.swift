//
//  SampleCats.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

let cats: [Cat] = (1...100).map { integer in
    let url = URL(string: "http://example.com/image\(integer).jpg")!
    return Cat(name: "test", identifier: integer, imageUrl: url)
}

let fullCatJSON = [
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
