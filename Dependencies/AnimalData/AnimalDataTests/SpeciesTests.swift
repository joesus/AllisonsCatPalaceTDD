//
//  SpeciesTests.swift
//  AnimalDataTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import XCTest

class SpeciesTests: XCTestCase {

    func testAllCases() {
        let species = Species.dog

        switch species {
        case .cat, .dog:
            break
        }
    }

}
