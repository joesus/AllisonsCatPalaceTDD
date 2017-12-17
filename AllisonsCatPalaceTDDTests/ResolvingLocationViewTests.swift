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

        XCTAssertTrue(activityIndicator.isAnimating,
                      "Resolving location view's activity indicator should be animating by default")
        XCTAssertTrue(activityIndicator.hidesWhenStopped,
                      "Resolving location view's activity indicator should hide when stopped")
    }

    func testActivityIndicator() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvingLocationView(frame: frame)
        guard let activityIndicator = view.activityIndicator else {
            return XCTFail("Resolving location view should contain an activity indicator")
        }

        view.isHidden = true
        XCTAssertFalse(activityIndicator.isAnimating,
                       "Activity indicator should stop animating when the view is hidden")

        view.isHidden = false
        XCTAssertTrue(activityIndicator.isAnimating,
                      "Activity indicator should begin animating when the view is unhidden")
    }

    func testHasProgressLabel() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ResolvingLocationView(frame: frame)
        guard let label = view.progressLabel else {
            return XCTFail("Resolving location view should contain a progress label")
        }

        XCTAssertEqual(label.text, "Finding Location",
                      "Resolving location view's label should have the expected text")
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
