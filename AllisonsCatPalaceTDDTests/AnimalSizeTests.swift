//
//  AnimalSizeTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 6/24/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalSizeTests: XCTestCase {

    func testCannotCreateAnimalSizeFromEmptyString() {
        XCTAssertNil(AnimalSize(petFinderRawValue: ""),
                     "Should not create animal size from empty string")
    }

    func testAnimalSizeInitializerWithSingleCharacter() {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

        let validCharacters = ["S", "M", "L"]
        characters.forEach { character in
            if validCharacters.contains(String(character)) {
                XCTAssertNotNil(AnimalSize(petFinderRawValue: String(character)),
                                "\(character) should create an animal size")
            } else {
                XCTAssertNil(AnimalSize(petFinderRawValue: String(character)),
                             "\(character) should not create an animal size")
            }
        }
    }

    func testAnimalSizeInitializerWithTwoCharacters() {
        let strings = ["xs", "xl", "xL", "Xl", "XL"]

        strings.forEach { character in
            switch character {
            case "XL":
                XCTAssertNotNil(AnimalSize(petFinderRawValue: character),
                                "\(character) should create an animal size")
            default:
                XCTAssertNil(AnimalSize(petFinderRawValue: character),
                             "\(character) should not create an animal size")

            }
        }
    }

    func testAnimalSizeInitializerWithThreeCharacters() {
        XCTAssertNil(AnimalSize(petFinderRawValue: "XXL"),
                     "XXL should not create an animal size")
    }

    func testAllCases() {
        let animalSizes = [AnimalSize.small, .medium, .large, .extraLarge]

        animalSizes.forEach { size in
            switch size {
            case .small, .medium, .large, .extraLarge:
                break
            }
        }
    }
}
