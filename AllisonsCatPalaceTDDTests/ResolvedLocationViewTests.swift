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

    func testContainsAView() {
        let bundle = Bundle(for: ResolvedLocationView.self)
        guard let _ = bundle.loadNibNamed("ResolvedLocationView", owner: ResolvedLocationView().self)?.first as? UIView else {
            return XCTFail("Resolved location view did not contain a UIView")
        }
    }

    func testInitializingWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        XCTAssertFalse(ResolvedLocationView(frame: frame).subviews.isEmpty,
                       "Resolved location view should add subviews from nib when instantiated in code")
    }

    func testIsIBDesignable() {
        let view = ResolvedLocationView()
        view.subviews.forEach { $0.removeFromSuperview() }
        XCTAssertEqual(view.subviews, [],
                       "Resolved location view should have all subviews removed")
        view.prepareForInterfaceBuilder()
        XCTAssertFalse(view.subviews.isEmpty,
                       "Resolved location view should add subviews from nib when prepared for interface builder")
    }

    func testHasLocationIndicator() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvedLocationView(frame: frame)
        guard let locationIndicator = view.locationIndicator else {
            return XCTFail("Resolved location view should contain a location indicator")
        }

        XCTAssertEqual(locationIndicator.image, #imageLiteral(resourceName: "location-pin"),
                       "Resolved location view should have an indicator image of a pin")
    }

    func testHasLocationLabel() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvedLocationView(frame: frame)

        guard let label = view.locationLabel else {
            return XCTFail("Resolved location view should contain a location label")
        }

        XCTAssertEqual(label.text, "Location",
                       "Resolved location view's label should have the expected text")
        XCTAssertEqual(label.font, UIFont.preferredFont(forTextStyle: .title2),
                       "Resolved location view's label should have a title2 text style so that it can display larger sizes when needed")
        XCTAssertEqual(label.numberOfLines, 0,
                       "Resolved location view's label should have number of lines set to zero so that it display long text on multiple lines.")
        XCTAssertEqual(label.lineBreakMode, .byWordWrapping,
                       "Resolved location view's label should have line break mode set to word wrap so that it can display long text on multiple lines.")
        XCTAssertFalse(label.isHidden,
                       "Resolved location view's label should not be hidden")
    }

}

