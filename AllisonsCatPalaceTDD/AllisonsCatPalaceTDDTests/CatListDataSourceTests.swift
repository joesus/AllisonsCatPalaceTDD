//
//  CatListDataSourceTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatListDataSourceTests: XCTestCase {

    let controller = CatListController()
    var dataSource: UITableViewDataSource!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

        dataSource = controller as UITableViewDataSource
        tableView = controller.tableView
    }

    func testHasZeroSectionsWhenNoCats() {
        XCTAssertEqual(dataSource.numberOfSections!(in: tableView), 0,
                       "Number of sections should be zero when no cats are presents")
    }

    func testHasOneSectionWhenCatsPresent() {
        let cat = Cat(name: "test", identifier: 1)
        controller.cats.append(cat)
        XCTAssertEqual(dataSource.numberOfSections!(in: tableView), 1,
                       "Number of sections should be one if there are cats")
    }

    func testHasZeroRowsWhenNoCats() {
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 0,
                       "TableView should have zero rows when no cats are present")
    }

    func testDataSourceHasCorrectNumberOfRows() {
        let cat = Cat(name: "test", identifier: 1)
        controller.cats.append(cat)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 1,
                       "TableView should have one row when there is one cat")
    }

    // DataSourceTests
    // has cells that display:
    // - cat name
    // - cat photo (so model needs photo)
    // should have pulldown to reload
}
