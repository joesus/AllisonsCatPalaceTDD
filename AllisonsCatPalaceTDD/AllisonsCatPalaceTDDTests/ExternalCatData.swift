//
//  ExternalCatData.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct ExternalCatData {
    static let valid: [String: Any] = ["name": "CatOne", "id": 1]
    static let anotherValid: [String: Any] = ["name": "CatTwo", "id": 2]
    static let withURLString: [String: Any] = ["name": "Cat", "id": 3, "pictureURL": "https://example.com/foo.gif"]
    static let withBadURLString: [String: Any] = ["name": "Cat", "id": 4, "pictureURL": "blah blah"]
    static let missingIdentifier: [String: Any] = ["name": "CatOne"]
    static let missingName: [String: Any] = ["id": 1]
    static let invalid: [String: Any] = [:]
}
