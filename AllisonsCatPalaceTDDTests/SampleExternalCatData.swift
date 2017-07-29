//
//  SampleExternalCatData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

struct SampleExternalCatData {
    static let valid: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatOne"
        ],
        ExternalCatKeys.id: [
            "$t": "1"
        ]
    ]
    static let anotherValid: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatTwo"
        ],
        ExternalCatKeys.id: [
            "$t": "2"
        ]
    ]
    static let validImageUrlString =      "http://photos.petfinder.com/photos/pets/1/2?bust=1416765384&width=500&-x.jpg"
    static let equivalentImageUrlString = "http://photos.petfinder.com/photos/pets/1/../1/2?bust=1416765384&width=500&-x.jpg"
    static let invalidImageUrlString = "blah blah blah"
    static let photos: PhotoArray = [
        [
            ExternalCatKeys.photoSize: "pnt",
            "$t": validImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "fpm",
            "$t": validImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "x",
            "$t": validImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "x",
            "$t": equivalentImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "x",
            "$t": invalidImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "t",
            "$t": validImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "t",
            "$t": equivalentImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "t",
            "$t": invalidImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "pn",
            "$t": validImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "pn",
            "$t": equivalentImageUrlString
        ],
        [
            ExternalCatKeys.photoSize: "pn",
            "$t": invalidImageUrlString
        ]
    ]
    static let withBadImageLocationStrings: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "Cat"
        ],
        ExternalCatKeys.id:  [
            "$t": "4"
        ],
        ExternalCatKeys.media: [
            ExternalCatKeys.photos: [
                ExternalCatKeys.photo: [
                    [
                        ExternalCatKeys.photoSize: "x",
                        "$t": "blah blah blah"
                    ],
                    [
                        ExternalCatKeys.photoSize: "t",
                        "$t": "blah blah blah"
                    ],
                    [
                        ExternalCatKeys.photoSize: "pn",
                        "$t": "blah blah blah"
                    ]
                ] as PhotoArray
            ]
        ] as JsonObject
    ]
    static let missingIdentifier: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatOne"
        ]
    ]
    static let missingName: ExternalCat = [
        ExternalCatKeys.id: [
            "$t": "1"
        ]
    ]
    static let invalid: ExternalCat = [:]
    static let female: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatTwo"
        ],
        ExternalCatKeys.id: [
            "$t": "2"
        ],
        ExternalCatKeys.sex: [
            "$t": "F"
        ]
    ]
    static let male: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatTwo"
        ],
        ExternalCatKeys.id: [
            "$t": "2"
        ],
        ExternalCatKeys.sex: [
            "$t": "M"
        ]
    ]
    static let neutered: ExternalCat = [
        ExternalCatKeys.name: [
            "$t": "CatTwo"
        ],
        ExternalCatKeys.id: [
            "$t": "2"
        ],
        ExternalCatKeys.sex: [
            "$t": "asdfasdf"
        ]
    ]
    static let emptyStatus: ExternalCat = {
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
        ExternalCatKeys.age: [
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
        ExternalCatKeys.favorites: [
            [
                "category": "hat",
                "value": "cowboy baby"
            ]
        ],
        ExternalCatKeys.sex: [
            "$t": "M"
        ],
        ExternalCatKeys.name: [
            "$t": "CatTwo"
        ],
        ExternalCatKeys.id: [
            "$t": "2"
        ],
        "size": [
            "$t": "L"
        ]
        ] as ExternalCat
}
