//
//  CatDetailViewControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/26/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatDetailViewControllerTests: XCTestCase {

    let controller = CatDetailController()

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "CatListController should be a UITableViewController")
    }

    func testDoesNotHaveCatByDefault() {
        XCTAssertNil(controller.cat, "Should not have a cat unless specified")
    }

    // TODO:- Make sure the other view lifecycle methods are protected
    func testViewDidLoadCallsSuperViewDidLoad() {
        UIViewController.beginSpyingOnViewDidLoad()
        controller.loadViewIfNeeded()
        XCTAssert(controller.viewDidLoadWasCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        UIViewController.endSpyingOnViewDidLoad()
    }

    func testReloadDataIsCalledWhenCatIsUpdated() {}

    func testAlwaysHasOneSection() {
        // assert equals one
        // add cat
        // assert equals one
    }

    func testFirstSectionHasCustomSectionHeaderView() {
        // 
    }


}
