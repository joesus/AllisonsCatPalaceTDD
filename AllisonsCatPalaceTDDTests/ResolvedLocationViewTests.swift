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
        typealias DisplayableLocation = (
            city: String?,
            state: String?,
            zip: ZipCode
        )
        typealias DisplayedLocation = (location: DisplayableLocation, displayedValue: String)

        let city = "Denver".displayableString!
        let state = "Colorado".displayableString!
        let zip = ZipCode(rawValue: "80220")!

        let testValues: [DisplayedLocation] = [
            ((city, state, zip), "\(city), \(state)"),
            ((city, nil, zip), "\(zip.rawValue) (\(city))"),
            ((nil, state, zip), "\(zip.rawValue) (\(state))"),
            ((nil, nil, zip), zip.rawValue)
        ]

        testValues.forEach { value in
            let name = ResolvedLocationView.SimplifiedLocationName(
                zipCode: value.location.zip,
                city: value.location.city,
                state: value.location.state
            )

            view.configure(locationName: name)

            XCTAssertEqual(label.text, value.displayedValue,
                           "Resolved location view's label should have different value depending on the input")
        }
    }

}
