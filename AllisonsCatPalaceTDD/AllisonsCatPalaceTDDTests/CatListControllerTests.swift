//
//  CatListControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatListControllerTests: XCTestCase {

    let controller = CatListController()

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "CatListController should be a UITableViewController")
    }

    func testHasNoCatsByDefault() {
        XCTAssert(controller.cats.isEmpty, "CatListController should have no cats by default")
    }

    func testViewDidLoadCallsSuperViewDidLoad() {
        UIViewController.beginSpyingOnViewDidLoad()
        controller.loadViewIfNeeded()
        XCTAssert(controller.viewDidLoadWasCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        UIViewController.endSpyingOnViewDidLoad()
    }

    func testRequestsCatsOnViewDidLoad() {

        controller.loadViewIfNeeded()
        CatDataSource.fetchAllCats(completion: {_ in})
//        XCTAssert(CatDataSource.fetchAllCatsWasCalled, "ViewDidLoad should request cats")

    }

    // handles results
    // with empty: nothing, don't reloadData
    // with results: reloadData

    // DataSourceTests
    // has cells that display:
    // - cat name
    // - cat photo (so model needs photo)
    // should have pulldown to reload

}






