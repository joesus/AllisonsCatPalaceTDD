//
//  SampleExternalAnimalData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

struct SampleExternalAnimalData {
    static func wrap(animal: ExternalAnimal) -> JsonObject {
        return [
            "petfinder": [
                "pet": animal
            ]
        ]
    }

    static func wrap(animals: [ExternalAnimal]) -> JsonObject {
        return [
            "petfinder": [
                "pets": [
                    "pet": animals
                ]
            ]
        ]
    }

    static let valid: ExternalAnimal = [
        "name": [
            "$t": "CatOne"
        ],
        "id": [
            "$t": "1"
        ]
    ]
    static let anotherValid: ExternalAnimal = [
        "name": [
            "$t": "CatTwo"
        ],
        "id": [
            "$t": "2"
        ]
    ]
    static let validImageUrlString =      "http://photos.petfinder.com/photos/pets/1/2?bust=1416765384&width=500&-x.jpg"
    static let equivalentImageUrlString = "http://photos.petfinder.com/photos/pets/1/../1/2?bust=1416765384&width=500&-x.jpg"
    static let invalidImageUrlString = "blah blah blah"
    static let photos: PhotoArray = [
        [
            "@size": "pnt",
            "$t": validImageUrlString
        ],
        [
            "@size": "fpm",
            "$t": validImageUrlString
        ],
        [
            "@size": "x",
            "$t": validImageUrlString
        ],
        [
            "@size": "x",
            "$t": equivalentImageUrlString
        ],
        [
            "@size": "x",
            "$t": invalidImageUrlString
        ],
        [
            "@size": "t",
            "$t": validImageUrlString
        ],
        [
            "@size": "t",
            "$t": equivalentImageUrlString
        ],
        [
            "@size": "t",
            "$t": invalidImageUrlString
        ],
        [
            "@size": "pn",
            "$t": validImageUrlString
        ],
        [
            "@size": "pn",
            "$t": equivalentImageUrlString
        ],
        [
            "@size": "pn",
            "$t": invalidImageUrlString
        ]
    ]
    static let withBadImageLocationStrings: ExternalAnimal = [
        "name": [
            "$t": "Cat"
        ],
        "id":  [
            "$t": "4"
        ],
        "media": [
            "photos": [
                "photo": [
                    [
                        "@size": "x",
                        "$t": "blah blah blah"
                    ],
                    [
                        "@size": "t",
                        "$t": "blah blah blah"
                    ],
                    [
                        "@size": "pn",
                        "$t": "blah blah blah"
                    ]
                ] as PhotoArray
            ]
        ] as JsonObject
    ]
    static let missingIdentifier: ExternalAnimal = [
        "name": [
            "$t": "CatOne"
        ]
    ]
    static let missingName: ExternalAnimal = [
        "id": [
            "$t": "1"
        ]
    ]
    static let invalid: ExternalAnimal = [:]
    static let female: ExternalAnimal = [
        "name": [
            "$t": "CatTwo"
        ],
        "id": [
            "$t": "2"
        ],
        "sex": [
            "$t": "F"
        ]
    ]
    static let male: ExternalAnimal = [
        "name": [
            "$t": "CatTwo"
        ],
        "id": [
            "$t": "2"
        ],
        "sex": [
            "$t": "M"
        ]
    ]
    static let neutered: ExternalAnimal = [
        "name": [
            "$t": "CatTwo"
        ],
        "id": [
            "$t": "2"
        ],
        "sex": [
            "$t": "asdfasdf"
        ]
    ]
    static let emptyStatus: ExternalAnimal = {
        var status = male
        status["status"] = JsonObject()
        return status
    }()
    static let full = [
        "description": [
            "$t": "I am a cat"
        ],
        "status": [
            "$t": "A"
        ],
        "age": [
            "$t": "Young"
        ],
        "contact": [
            "city": [
                "$t": "Denver"
            ],
            "state": [
                "$t": "CO"
            ]
        ],
        "favorites": [
            [
                "category": "hat",
                "value": "cowboy baby"
            ]
        ],
        "sex": [
            "$t": "M"
        ],
        "name": [
            "$t": "CatTwo"
        ],
        "id": [
            "$t": "2"
        ],
        "size": [
            "$t": "L"
        ]
        ] as ExternalAnimal
}
