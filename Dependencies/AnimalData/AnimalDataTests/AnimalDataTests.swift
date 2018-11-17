//
//  AnimalDataTests.swift
//  AnimalDataTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import XCTest

class AnimalDataTests: XCTestCase {

    let animal = AnimalData(
        name: "Joe",
        species: .dog
    )

    func testName() {
        XCTAssertEqual(animal.name, "Joe",
                       "Name is required as part of the AnimalData interface")
    }

    func testSpecies() {
        XCTAssertEqual(animal.species, .dog,
                       "Species is required as part of the AnimalData interface")
    }

}
