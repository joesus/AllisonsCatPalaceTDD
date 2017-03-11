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

    let cat = cats.first!
    let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
    let url = URL(string: "https://example.com/testCat.png")!
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! CatListController
    var dataSource: UITableViewDataSource!
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)

    override func setUp() {
        super.setUp()

        controller.loadViewIfNeeded()
        dataSource = controller as UITableViewDataSource
        tableView = controller.tableView
        ImageProvider.reset()
    }

    override func tearDown() {
        ImageProvider.reset()

        super.tearDown()
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

    func testCatCellHasImageView() {
        XCTAssertNotNil(CatCell().imageView)
    }

    func testDataSourceReturnsCatCells() {
        controller.cats.append(cat)
        guard let _ = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath) as? CatCell else {
            return XCTFail("DataSource should return Cat Cells")
        }
    }

    func testCatCellDisplaysCatName() {
        controller.cats.append(cat)
        let cell = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath)
        XCTAssertEqual(cell.textLabel!.text, "test", "First cell should display the name of the first cat")
    }

    func testCatCellImageViewHasDefaultImage() {
        controller.cats.append(cat)
        let cell = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath)
        XCTAssertEqual(cell.imageView?.image, #imageLiteral(resourceName: "catOutline"),
                       "The default image for a cat cell should be the cat outline")
    }

    func testCatCellUsesCachedImageIfAvailable() {
        controller.cats.append(cat)
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: url))

        // Need to force it to load the cell at that IndexPath
        let _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        let cell = tableView.cellForRow(at: firstCatIndexPath)
        XCTAssertEqual(UIImagePNGRepresentation((cell?.imageView?.image)!), imageData,
                       "When available the image should populate from the cache")
    }

    func testCatCellDoesNotReloadIfNotVisible() {
        UITableView.beginSpyingOnReloadRows()
        URLSession.beginSpyingOnDataTaskCreation()

        // adds all the cats
        controller.cats.append(contentsOf: cats)

        // triggers the fetch by getting a cell from the dataSource
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // scrolls the cell out of view
        tableView.scrollToRow(at: IndexPath(row: 75, section: 0), at: .bottom, animated: false)

        // call the completion handler
        let handler = URLSession.shared.capturedCompletionHandler
        handler?(imageData, response200(), nil)

        // check that the cell isn't reloaded
        XCTAssertFalse(tableView.reloadRowsWasCalled,
                       "Should not call reloadRows(at: with:) if the cell is off-screen")

        UITableView.endSpyingOnReloadRows()
        URLSession.endSpyingOnDataTaskCreation()
    }

    func testCatCellReloadsIfVisible() {
        UITableView.beginSpyingOnReloadRows()
        URLSession.beginSpyingOnDataTaskCreation()

        // adds all the cats
        controller.cats.append(contentsOf: cats)

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // call the completion handler
        let handler = URLSession.shared.capturedCompletionHandler
        handler?(imageData, response200(), nil)

        // check that the cell is reloaded
        XCTAssertTrue(tableView.reloadRowsWasCalled,
                       "Should not call reloadRows(at: with:) if the cell is off-screen")
        // with the correct indexPath
        XCTAssertEqual(tableView.reloadRowsIndexPaths!, [firstCatIndexPath],
                       "Should try to reload the correct indexPath when cell is visible")
        // and correct animation
        XCTAssertEqual(tableView.reloadRowsAnimation, .bottom,
                       "Should try to reload with the correct animation when cell is visible")

        UITableView.endSpyingOnReloadRows()
        URLSession.endSpyingOnDataTaskCreation()
    }

    func testUnsuccessfulImageFetchDoesNotReloadCell() {
    }
}
