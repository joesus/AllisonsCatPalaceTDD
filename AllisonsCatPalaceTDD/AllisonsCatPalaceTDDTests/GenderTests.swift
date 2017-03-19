//
//  GenderTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class GenderTests: XCTestCase {
    
    func testHasThreeCases() {
        let gender = Gender.unknown
        switch gender {
        case .male, .female, .unknown:
            break
        }
    }
}
