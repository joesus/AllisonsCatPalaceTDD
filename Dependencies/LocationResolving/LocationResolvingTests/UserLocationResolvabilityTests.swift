//
//  UserLocationResolvabilityTests.swift
//  LocationResolvingTests
//
//  Created by Joe Susnick on 12/24/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import LocationResolving
import XCTest

class UserLocationResolvabilityTests: XCTestCase {

    func testAllCases() {
        let possibleValues: [UserLocationResolvability] = [
            .unknown,
            .allowed,
            .disallowed
        ]

        possibleValues.forEach { value in
            switch value {
            case .unknown,
                 .allowed,
                 .disallowed:
                break
            }
        }
    }

    func testEquatability() {
        let allValues: [UserLocationResolvability] = [
            .unknown,
            .allowed,
            .disallowed
        ]

        allValues.forEach { value in
            XCTAssertEqual(value, value,
                           "\(value) should equal \(value)")
        }

        allValues.enumerated().forEach { index, value in
            var others = allValues
            others.remove(at: index)

            others.forEach { other in
                XCTAssertNotEqual(value, other, "Different values should be unequal")
            }
        }
    }

}
