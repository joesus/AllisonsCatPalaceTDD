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

    let view = ResolvingLocationView()
    let activityIndicator = UIActivityIndicatorView()
    let label = UILabel()

    override func setUp() {
        super.setUp()

        view.activityIndicator = activityIndicator
        view.progressLabel = label
    }

    func testActivityIndicatorControl() {
        view.isHidden = true
        XCTAssertFalse(activityIndicator.isAnimating,
                       "Activity indicator should stop animating when the view is hidden")

        view.isHidden = false
        XCTAssertTrue(activityIndicator.isAnimating,
                      "Activity indicator should begin animating when the view is unhidden")
    }
    
}
