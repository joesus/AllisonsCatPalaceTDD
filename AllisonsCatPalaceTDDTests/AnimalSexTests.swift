//
//  AnimalSexTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalSexTests: XCTestCase {
    func testCannotCreateAnimalSexFromEmptyString() {
        XCTAssertNil(AnimalSex(petFinderRawValue: ""),
                     "Should not create animal sex from empty string")
    }

    func testAnimalSexInitializerWithSingleCharacter() {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

        let validCharacters = ["M", "F"]
        characters.forEach { character in
            if validCharacters.contains(String(character)) {
                XCTAssertNotNil(AnimalSex(petFinderRawValue: String(character)),
                                "\(character) should create an animal sex")
            } else {
                XCTAssertNil(AnimalSex(petFinderRawValue: String(character)),
                             "\(character) should not create an animal sex")
            }
        }
    }

    func testAnimalSexInitializerWithInvalidStrings() {
        let strings = ["male", "female"]

        strings.forEach { character in
            XCTAssertNil(AnimalSex(petFinderRawValue: character),
                             "\(character) should not create an animal sex")
        }
    }

    func testAllCases() {
        let animalSexes = [AnimalSex.male, .female]

        animalSexes.forEach { sex in
            switch sex {
            case .male, .female:
                break
            }
        }
    }
}
