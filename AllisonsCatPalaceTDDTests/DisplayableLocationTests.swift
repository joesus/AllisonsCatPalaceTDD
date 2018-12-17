//
//  DisplayableLocationTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class DisplayableLocationTests: XCTestCase {

    var placemark: DisplayablePlacemark!

    func testCreatingWithoutValues() {
        placemark = TestDisplayablePlacemark()

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "Unknown",
                       "A placemark without any usable values should show a message conveying that location is unknown")
    }

    func testCreatingWithPostalCodeOnly() {
        placemark = TestDisplayablePlacemark(postalCode: "12345")

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "12345",
                       "A placemark without only a postal code should display the postal code")
    }

    func testCreatingWithLocalityOnly() {
        placemark = TestDisplayablePlacemark(locality: "denver")

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "denver",
                       "A placemark without only a locality should display the locality")
    }

    func testCreatingWithAdministrativeAreaOnly() {
        placemark = TestDisplayablePlacemark(administrativeArea: "CO")

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "CO",
                       "A placemark without only an administrative area should display the administrative area")
    }

    func testCreatingWithAllValues() {
        placemark = TestDisplayablePlacemark(
            postalCode: "123",
            locality: "denver",
            administrativeArea: "CO"
        )

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "denver, CO",
                       "A placemark with all values should only display the locality and administrative area")
    }

    func testWithoutPostalCode() {
        placemark = TestDisplayablePlacemark(
            locality: "denver",
            administrativeArea: "CO"
        )

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "denver, CO",
                       "A placemark missing only a postal code should display the locality and administrative area")
    }

    func testWithoutLocality() {
        placemark = TestDisplayablePlacemark(
            postalCode: "12345",
            administrativeArea: "CO"
        )

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "12345 (CO)",
                       "A placemark missing only a locality should display the postal code and administrative area")
    }

    func testWithoutAdministrativeArea() {
        placemark = TestDisplayablePlacemark(
            postalCode: "12345",
            locality: "denver"
        )

        XCTAssertEqual(DisplayableLocation(placemark: placemark).displayableString, "12345 (denver)",
                       "A placemark missing only an administrative area should display the postal code and locality")
    }

}
