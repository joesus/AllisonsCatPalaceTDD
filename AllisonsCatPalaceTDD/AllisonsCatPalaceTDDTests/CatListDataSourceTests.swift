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
        UITableView.beginSpyingOnReloadRows()
        URLSession.beginSpyingOnDataTaskCreation()
        URLSessionDataTask.beginSpyingOnResume()
    }

    override func tearDown() {
        ImageProvider.reset()
        UITableView.endSpyingOnReloadRows()
        URLSession.endSpyingOnDataTaskCreation()
        URLSessionDataTask.endSpyingOnResume()

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
        let response = URLResponse(url: cat.imageUrl!, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: cat.imageUrl!))

        // Need to force it to load the cell at that IndexPath
        let _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        let cell = tableView.cellForRow(at: firstCatIndexPath)
        XCTAssertEqual(UIImagePNGRepresentation((cell!.imageView!.image)!), imageData,
                       "When available the image should populate from the cache")
    }

    func testCatCellDoesNotReloadIfNotVisible() {
        let didNotReloadExpectation = expectation(description: "testCatCellDoesNotReloadIfNotVisible")

        // adds all the cats
        controller.cats.append(contentsOf: cats)

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // scrolls the cell out of view
        tableView.scrollToRow(at: IndexPath(row: 75, section: 0), at: .bottom, animated: false)

        // call the completion handler
        let handler = URLSession.shared.capturedCompletionHandler

        DispatchQueue.global(qos: .background).async {
            handler?(self.imageData, response200(), nil)
            Thread.sleep(forTimeInterval: 0.1)
            didNotReloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3, handler: nil)

        // check that the cell isn't reloaded
        XCTAssertFalse(tableView.reloadRowsWasCalled,
                       "Should not call reloadRows(at: with:) if the cell is off-screen")
    }

    func testCatCellReloadsIfVisible() {
        let reloadedPredicate = NSPredicate { [tableView] _,_ in
            tableView!.reloadRowsWasCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        // adds all the cats
        controller.cats.append(contentsOf: cats)

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // call the completion handler
        let handler = URLSession.shared.capturedCompletionHandler

        DispatchQueue.global(qos: .background).async {
            handler!(self.imageData, response200(url: cats.first!.imageUrl!), nil)
        }

        waitForExpectations(timeout: 1, handler: nil)

        // check that the cell is reloaded
        XCTAssertTrue(tableView.reloadRowsWasCalled,
                      "Should call reloadRows(at: with:) if the cell is on-screen")
        // with the correct indexPath
        XCTAssertEqual(tableView.reloadRowsIndexPaths!, [firstCatIndexPath],
                       "Should try to reload the correct indexPath when cell is visible")
        // and correct animation
        XCTAssertEqual(tableView.reloadRowsAnimation, .automatic,
                       "Should try to reload with the correct animation when cell is visible")
        // and on the right thread
        XCTAssertTrue(tableView.reloadRowsCalledOnMainThread!,
                      "Should call reloadRows on the main thread regardless of the thread the handler is called on")
    }

    func testUnsuccessfulImageFetchDoesNotReloadCell() {
        let didNotReloadExpectation = expectation(description: "testUnsuccessfulImageFetchDoesNotReloadCell")

        // adds all the cats
        controller.cats.append(contentsOf: cats)

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // call the completion handler on the background thread
        let handler = URLSession.shared.capturedCompletionHandler
        DispatchQueue.global(qos: .background).async {
            handler!(nil, response200(url: cats.first!.imageUrl!), nil)
            // sleep on background thread
            Thread.sleep(forTimeInterval: 0.2)
            didNotReloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.3, handler: nil)

        // check that the cell is reloaded
        XCTAssertFalse(tableView.reloadRowsWasCalled,
                      "Should not call reloadRows(at: with:) if unsuccessful image fetch")

    }
}
