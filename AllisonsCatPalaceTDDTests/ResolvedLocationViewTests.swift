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
            zip: String?
        )
        typealias DisplayedLocation = (location: DisplayableLocation, displayedValue: String)

        let city = "Denver".displayableString!
        let state = "Colorado".displayableString!
        let zip = "80220".displayableString!

        let testValues: [DisplayedLocation] = [
            ((city, nil, nil), city),
            ((city, state, zip), "\(city), \(state)"),
            ((city, state, nil), "\(city), \(state)"),
            ((city, nil, zip), "\(zip) (\(city))"),
            ((nil, state, zip), "\(zip) (\(state))"),
            ((nil, state, nil), state),
            ((nil, nil, zip), zip),
            ((nil, nil, nil), "Location Unknown")
        ]

        testValues.forEach { value in
            view.configure(
                city: value.location.city,
                state: value.location.state,
                zip: value.location.zip
            )

            XCTAssertEqual(label.text, value.displayedValue,
                           "Resolved location view's label should have different value depending on the input")
        }
    }

}
