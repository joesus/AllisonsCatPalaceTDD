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

    let cat = Cat(name: "test", identifier: 1)
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! CatListController
    var dataSource: UITableViewDataSource!
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)

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
        controller.cats.append(cat)
        XCTAssertEqual(dataSource.numberOfSections!(in: tableView), 1,
                       "Number of sections should be one if there are cats")
    }

    func testHasZeroRowsWhenNoCats() {
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 0,
                       "TableView should have zero rows when no cats are present")
    }

    func testDataSourceHasCorrectNumberOfRows() {
        controller.cats.append(cat)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 1,
                       "TableView should have one row when there is one cat")
    }

    func testCatCellIsRegisteredWithTableView() {
        controller.cats.append(cat)
        controller.loadViewIfNeeded()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: firstCatIndexPath)
        XCTAssert(cell is CatCell, "CatCells should be registered with the tableView")
    }

    func testCatCellHasTextLabel() {
        XCTAssertNotNil(CatCell().textLabel, "CatCell should have a textLabel")
    }

    func testCatCellHasNoDetailTextLabel() {
        XCTAssertNil(CatCell().detailTextLabel, "CatCell should not have a detailTextLabel")
    }

    func testDataSourceReturnsCatCells() {
        controller.cats.append(cat)
        guard let _ = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CatCell else {
            return XCTFail("DataSource should return Cat Cells")
        }
    }

    func testCatCellDisplaysCatName() {
        controller.cats.append(cat)
        let cell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel!.text, "test", "First cell should display the name of the first cat")
    }

    // DataSourceTests
    // has cells that display:
    // - cat photo (so model needs photo)
    // should have pulldown to reload
}
