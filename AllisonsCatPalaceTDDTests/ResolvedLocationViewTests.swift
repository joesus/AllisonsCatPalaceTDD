//
//  ResolvedLocationViewTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest

@testable import AllisonsCatPalaceTDD

class ResolvedLocationViewTests: XCTestCase {

    let view = ResolvedLocationView()
    let imageView = UIImageView()
    let label = UILabel()

    override func setUp() {
        super.setUp()

        view.icon = imageView
        view.label = label
    }

    func testConfiguringWithLocationData() {
        let placemark = TestDisplayablePlacemark(
            postalCode: "12345",
            locality: "foo",
            administrativeArea: "bar"
        )
        let location = DisplayableLocation(placemark: placemark)
        view.configure(location: location)

        XCTAssertEqual(label.text, location.displayableString,
                       "The label's value should be taken from the location's displayable string")
    }

}
