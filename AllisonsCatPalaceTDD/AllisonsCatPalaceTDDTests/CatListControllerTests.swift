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

//    func testRequestsCatsOnViewDidLoad() {
//        controller.loadViewIfNeeded()
//        CatDataSource.fetchAllCats(completion: {_ in})
//        XCTAssert(CatDataSource.fetchAllCatsWasCalled, "ViewDidLoad should request cats")
//    }

    func testReloadDataIsCalledWhenCatsAreUpdated() {
        UITableView.beginSpyingOnReloadData()
        let cat = Cat(name: "Test", identifier: 1)
        controller.cats.append(cat)
        XCTAssert(controller.tableView.reloadDataWasCalled, "TableView should be reloaded when cats are updated")
        UITableView.endSpyingOnReloadData()
    }
}






