//
//  SwipeOverlayViewTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest
import Koloda

class SwipeOverlayViewTests: XCTestCase {
    var swipeOverlayView: SwipeOverlayView!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: SwipeOverlayView.self)
        guard let view = bundle.loadNibNamed("SwipeOverlayView", owner: SwipeOverlayView().self)?.first as? SwipeOverlayView else {
            return XCTFail("Should be able to instantiate SwipeOverlayView from nib")
        }

        swipeOverlayView = view
    }

    func testHasImageView() {
        XCTAssertNotNil(swipeOverlayView.imageView,
                        "Swipe overlay view should have an image view to set the overlay on")
    }

    func testOverlayState() {
        swipeOverlayView.overlayState = nil
        XCTAssertNil(swipeOverlayView.imageView.image,
                     "Swipe overlay view should have no image when overlay state is nil")

        swipeOverlayView.overlayState = .left
        XCTAssertEqual(swipeOverlayView.imageView.image, #imageLiteral(resourceName: "noOverlayImage"),
                       "Should set correct image for left overlay state")

        swipeOverlayView.overlayState = .right
        XCTAssertEqual(swipeOverlayView.imageView.image, #imageLiteral(resourceName: "yesOverlayImage"),
                       "Should set correct image for right overlay state")
    }


}
