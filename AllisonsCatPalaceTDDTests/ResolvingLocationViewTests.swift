//
//  ResolvingLocationViewTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class ResolvingLocationViewTests: XCTestCase {
    
    func testContainsAView() {
        let bundle = Bundle(for: ResolvingLocationView.self)
        guard let _ = bundle.loadNibNamed("ResolvingLocationView", owner: ResolvingLocationView().self)?.first as? UIView else {
            return XCTFail("Resolving location view did not contain a UIView")
        }
    }

    func testInitializingWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        XCTAssertFalse(ResolvingLocationView(frame: frame).subviews.isEmpty,
                       "Resolving location view should add subviews from nib when instantiated in code")
    }

    func testIsIBDesignable() {
        let view = ResolvingLocationView()
        view.subviews.forEach { $0.removeFromSuperview() }
        XCTAssertEqual(view.subviews, [],
                       "Resolving location view should have all subviews removed")
        view.prepareForInterfaceBuilder()
        XCTAssertFalse(view.subviews.isEmpty,
                       "Resolving location view should add subviews from nib when prepared for interface builder")
    }

    func testHasActivityIndicator() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvingLocationView(frame: frame)
        guard let activityIndicator = view.activityIndicator else {
            return XCTFail("Resolving location view should contain an activity indicator")
        }

        XCTAssertTrue(activityIndicator.hidesWhenStopped,
                      "Resolving location view's activity indicator should hide when stopped")
    }

    func testHasProgressLabel() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvingLocationView(frame: frame)
        guard let label = view.progressLabel else {
            return XCTFail("Resolving location view should contain a progress label")
        }

        XCTAssertEqual(label.text, "Finding Location",
                      "Resolving location view's label should have the expected text")
    }

}
