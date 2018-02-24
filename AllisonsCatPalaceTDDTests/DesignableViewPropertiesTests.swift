//
//  DesignableViewPropertiesTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 2/24/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class DesignableViewPropertiesTests: XCTestCase {

    let view = UIView()

    func testBorderWidth() {
        XCTAssertEqual(view.borderWidth, 0, "A view should have no border by default")

        view.borderWidth = 4.2
        XCTAssertEqual(view.layer.borderWidth, 4.2,
                       "Setting the border width on a view should update its layer")

        view.layer.borderWidth = 1.4
        XCTAssertEqual(view.borderWidth, 1.4,
                       "A view's layer's border width should be reflected by the view's border width")
    }

    func testCornerRadius() {
        XCTAssertEqual(view.cornerRadius, 0, "A view should have no corner radius by default")

        view.cornerRadius = 4.2
        XCTAssertEqual(view.layer.cornerRadius, 4.2,
                       "Setting the corner radius on a view should update its layer")

        view.layer.cornerRadius = 1.4
        XCTAssertEqual(view.cornerRadius, 1.4,
                       "A view's layer's corner radius should be reflected by the view's corner radius")
    }

    func testBorderColor() {
        XCTAssertEqual(view.borderColor?.cgColor, view.layer.borderColor,
                       "A view's border color should reflect the its layer's border color")

        view.borderColor = .red
        XCTAssertEqual(view.layer.borderColor, UIColor.red.cgColor,
                       "Setting a view's border color should update its layer")

        view.layer.borderColor = UIColor.blue.cgColor
        XCTAssertEqual(view.borderColor, .blue,
                       "A view's layer's border color should be reflected by the view's border color")
    }

}
