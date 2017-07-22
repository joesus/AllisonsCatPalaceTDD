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
        XCTAssertEqual(AnimalSex(petFinderRawValue: ""), .unknown,
                     "Empty string should default to unknown value")
    }

    func testAnimalSexInitializerWithSingleCharacter() {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

        let validCharacters = ["M", "F"]
        characters.forEach { character in
            if validCharacters.contains(String(character)) {
                XCTAssertNotNil(AnimalSex(petFinderRawValue: String(character)),
                                "\(character) should create an animal sex")
            } else {
                XCTAssertEqual(AnimalSex(petFinderRawValue: String(character)), .unknown,
                             "\(character) should default to unknown")
            }
        }
    }

    func testAnimalSexInitializerWithInvalidStrings() {
        let strings = ["male", "female"]

        strings.forEach { character in
            XCTAssertEqual(AnimalSex(petFinderRawValue: String(character)), .unknown,
                           "\(character) should default to unknown")
        }
    }

    func testAllCases() {
        let animalSexes = [AnimalSex.male, .female, .unknown]

        animalSexes.forEach { sex in
            switch sex {
            case .male, .female, .unknown:
                break
            }
        }
    }
}
