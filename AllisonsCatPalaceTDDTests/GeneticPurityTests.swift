//
//  GeneticPurityTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class GeneticPurityTests: XCTestCase {
    
    func testPurityCases() {
        [GeneticPurity.purebred, .mixed].forEach { value in
            switch value {
            case .purebred, .mixed:
                break
            }
        }
    }

    func testInitializerWithinValidStrings() {
        ["YES", "NO", "Yes", "No", "", "Blah"].forEach { invalidString in
            XCTAssertNil(GeneticPurity(petFinderRawValue: invalidString),
                            "Should not create genetic purity from invalid strings")
        }
    }

    func testInitializeWithValidStrings() {
        ["yes", "no"].forEach { validString in
            XCTAssertNotNil(GeneticPurity(petFinderRawValue: validString),
                            "Should create genetic purity from valid strings")
        }
    }

    func testIsPurebredFlag() {
        XCTAssertTrue(GeneticPurity.purebred.isPurebred,
                      "Purebred should be purebred")
        XCTAssertFalse(GeneticPurity.mixed.isPurebred,
                       "Mixed should not be purebred")
    }
}
