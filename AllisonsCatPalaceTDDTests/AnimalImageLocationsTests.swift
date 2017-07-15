//
//  AnimalImageLocationsTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AnimalImageLocationsTests: XCTestCase {

    func testHasNoSizesByDefault() {
        let locations = AnimalImageLocations()
        XCTAssertTrue(locations.small.isEmpty,
                      "Animal image locations should have no small images by default")
        XCTAssertTrue(locations.medium.isEmpty,
                      "Animal image locations should have no medium images by default")
        XCTAssertTrue(locations.large.isEmpty,
                      "Animal image locations should have no large images by default")

    }

    func testCreatingWithSizes() {
        let small = [URL(string: "https://www.google.com")!,
                     URL(string: "https://www.google.com")!]
        let medium = [URL(string: "https://www.google.com")!,
                      URL(string: "https://www.google.com")!]
        let large = [URL(string: "https://www.google.com")!,
                     URL(string: "https://www.google.com")!,
                     URL(string: "https://www.apple.com")!]

        let locations = AnimalImageLocations(
            small: small,
            medium: medium,
            large: large
        )

        XCTAssertEqual(locations.small, [small[0]],
                       "Duplicate urls should be removed")
        XCTAssertEqual(locations.medium, [medium[0]],
                       "Medium locations should be created with provided location")
        XCTAssertEqual(locations.large, [large[0], large[2]],
                       "Multiple locations should be created if they are not duplicates")
    }
}
