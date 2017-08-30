//
//  FavoritesListDataSourceTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import TestSwagger
import TestableUIKit
@testable import AllisonsCatPalaceTDD

class FavoritesListDataSourceTests: XCTestCase {

    let cat = cats.first!
    let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
    let navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
    var controller: FavoritesListController!
    var dataSource: UITableViewDataSource!
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)
    var reloadRowsSpy: Spy?

    override func setUp() {
        super.setUp()

        loadComponents()
        ImageProvider.reset()
        reloadRowsSpy = UITableView.ReloadRowsSpyController.createSpy(on: tableView)
        reloadRowsSpy?.beginSpying()
        URLSession.beginSpyingOnDataTaskCreation()
        URLSessionDataTask.beginSpyingOnResume()
    }

    override func tearDown() {
        ImageProvider.reset()
        URLSession.endSpyingOnDataTaskCreation()
        URLSessionDataTask.endSpyingOnResume()
        reloadRowsSpy?.endSpying()

        controller = nil
        dataSource = nil
        tableView = nil
        reloadRowsSpy = nil

        super.tearDown()
    }

    func testHasZeroSectionsWhenNoAnimals() {
        XCTAssertEqual(dataSource.numberOfSections!(in: tableView), 0,
                       "Number of sections should be zero when no animals are presents")
    }

    func testHasOneSectionWhenAnimalsPresent() {
        controller.animals.append(cat)
        XCTAssertEqual(dataSource.numberOfSections!(in: tableView), 1,
                       "Number of sections should be one if there are animals")
    }

    func testHasZeroRowsWhenNoAnimals() {
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 0,
                       "TableView should have zero rows when no animals are present")
    }

    func testDataSourceHasCorrectNumberOfRows() {
        controller.animals.append(cat)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 1,
                       "TableView should have one row when there is one cat")
    }

    func testCatCellIsRegisteredWithTableView() {
        controller.animals.append(cat)
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
        controller.animals.append(cat)
        guard let _ = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath) as? CatCell else {
            return XCTFail("DataSource should return Cat Cells")
        }
    }

    func testCatCellDisplaysCatName() {
        loadComponents()

        controller.animals.append(cat)
        controller.loadViewIfNeeded()

        tableView = controller.tableView

        let cell = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath)
        XCTAssertEqual(cell.textLabel!.text, "test", "First cell should display the name of the first cat")
    }

    func testCatCellImageViewHasDefaultImage() {
        controller.animals.append(cat)
        let cell = dataSource.tableView(tableView, cellForRowAt: firstCatIndexPath)
        XCTAssertEqual(cell.imageView?.image, #imageLiteral(resourceName: "catOutline"),
                       "The default image for a cat cell should be the cat outline")
    }

    func testCatCellUsesCachedImageIfAvailable() {
        controller.animals.append(cat)
        let thumbnailUrl = cat.imageLocations.small.first!
        let response = URLResponse(url: thumbnailUrl, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: thumbnailUrl))

        // Need to force it to load the cell at that IndexPath
        let _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        let cell = tableView.cellForRow(at: firstCatIndexPath)
        XCTAssertEqual(UIImagePNGRepresentation((cell!.imageView!.image)!), imageData,
                       "When available the image should populate from the cache")
    }

    func testCatCellDoesNotReloadIfNotVisible() {
        let didNotReloadExpectation = expectation(description: "testCatCellDoesNotReloadIfNotVisible")

        loadComponents()

        // adds all the animals
        controller.animals.append(contentsOf: cats)

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

        waitForExpectations(timeout: 1, handler: nil)

        // check that the cell isn't reloaded
        XCTAssertFalse(tableView.reloadRowsCalled,
                       "Should not call reloadRows(at: with:) if the cell is off-screen")
    }

    func testCatCellReloadsIfVisible() {
        loadComponents()

        // adds all the animals
        controller.animals.append(contentsOf: cats)

        let reloadedPredicate = NSPredicate { [tableView] _,_ in
            tableView!.reloadRowsCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // call the completion handler
        let handler = URLSession.shared.capturedCompletionHandler


        DispatchQueue.global(qos: .background).async {
            handler!(self.imageData, response200(url: cats.first!.imageLocations.small.first!), nil)
        }

        waitForExpectations(timeout: 2, handler: nil)

        // check that the cell is reloaded
        guard tableView.reloadRowsCalled else {
            return XCTFail("Should call reloadRows(at: with:) if the cell is on-screen")
        }
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

        // adds all the animals
        controller.animals.append(contentsOf: cats)

        // grabs the thumbnail url for the first cat
        let thumbnailUrl = cats.first!.imageLocations.small.first!

        // triggers the fetch by getting a cell from the dataSource
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath)

        // call the completion handler on the background thread
        let handler = URLSession.shared.capturedCompletionHandler
        DispatchQueue.global(qos: .background).async {
            handler!(nil, response200(url: thumbnailUrl), nil)
            // sleep on background thread
            Thread.sleep(forTimeInterval: 0.2)
            didNotReloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        // check that the cell is reloaded
        XCTAssertFalse(tableView.reloadRowsCalled,
                      "Should not call reloadRows(at: with:) if unsuccessful image fetch")

    }
}

extension FavoritesListDataSourceTests {
    func loadComponents() {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesListController") as! FavoritesListController
        controller.loadViewIfNeeded()

        dataSource = controller as UITableViewDataSource
        tableView = controller.tableView
    }
}
