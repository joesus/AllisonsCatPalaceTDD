//
//  ZipCodeTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class ZipCodeTests: XCTestCase {

    func testInitializingWithBadValues() {
        ["1234x", "1234@", "@#$%1", "123", "001", "123 4", "", "123456"].forEach { badString in
            XCTAssertNil(ZipCode(rawValue: badString),
                         "Should not create a zip code with \(badString)")
        }
    }

    func testInitializingWithGoodValues() {
        ["00000", "00001", "99998", "99999", "80220", "90210"].forEach { string in
            guard let zip = ZipCode(rawValue: string) else {
                return XCTFail("Should create a zip code with \(string)")
            }

            XCTAssertEqual(zip.rawValue, string,
                           "Zip code should not alter the string that was passed in")
        }
    }

    func testEquatability() {
        let validZip = ZipCode(rawValue: "80220")!
        let sameZip = ZipCode(rawValue: "80220")!
        let differentZip = ZipCode(rawValue: "80221")!

        XCTAssertEqual(validZip, sameZip,
                       "Identical zip codes should be equal")
        XCTAssertNotEqual(validZip, differentZip,
                          "Different zip codes should not be equal")
    }

}
