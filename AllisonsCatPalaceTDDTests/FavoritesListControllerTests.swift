//
//  FavoritesListControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import TestableUIKit
@testable import AllisonsCatPalaceTDD

class FavoritesListControllerTests: XCTestCase {

    var controller: FavoritesListController!
    var navController: UINavigationController!
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)

    override func setUp() {
        super.setUp()

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        replaceRootViewController(with: navController) // the main controller for the window is now the navController

        URLSessionTask.beginStubbingResume()

        guard let favoritesListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesListController") as? FavoritesListController else {
            return XCTFail("Could not instantiate favorites list controller from main storyboard")
        }

        navController.addChildViewController(favoritesListController)
        controller = navController.topViewController as! FavoritesListController
        tableView = controller.tableView

    }

    override func tearDown() {
        restoreRootViewController()
        URLSessionTask.endStubbingResume()

        super.tearDown()
    }

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "FavoritesListController should be a UITableViewController")
    }

    func testHasNoAnimalsByDefault() {
        XCTAssert(controller.animals.isEmpty, "FavoritesListController should have no animals by default")
    }

    func testReloadDataIsCalledWhenAnimalsAreUpdated() {
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        UITableView.ReloadDataSpyController.createSpy(on: tableView)!.spy {
            DispatchQueue.global(qos: .background).async { [weak controller] in
                let cat = Animal(name: "Test", identifier: 1)
                controller?.animals.append(cat)
            }

            waitForExpectations(timeout: 2, handler: nil)
            XCTAssert(tableView.reloadDataCalled,
                      "TableView should be reloaded when animals are updated")
            XCTAssert(tableView.reloadDataCalledOnMainThread!,
                      "Reload data should be called on the main thread when animals are updated on a background thread")
        }
    }

    func testReloadDataIsCalledWhenAnimalsAreCleared() {
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        UITableView.ReloadDataSpyController.createSpy(on: tableView)!.spy {
            DispatchQueue.global(qos: .background).async { [weak controller] in
                controller?.animals = []
            }

            waitForExpectations(timeout: 2, handler: nil)

            guard controller.tableView.reloadDataCalled else {
                return XCTFail("TableView should be reloaded when animals are cleared")
            }

            XCTAssert(controller.tableView.reloadDataCalledOnMainThread!,
                      "Reload data should be called on the main thread when animals are cleared on a background thread")
        }
    }

    func testPrepareForSeguePreparesDetailController() {
        controller.animals = [SampleCat]

        guard let destination = UIStoryboard(name: "Main", bundle: Bundle(for: CatDetailController.self)).instantiateViewController(withIdentifier: "CatDetailController") as? CatDetailController else {
            return XCTFail("Main storyboard should have a cat detail controller scene")
        }

        let segue = UIStoryboardSegue(identifier: "ShowCatDetail", source: controller, destination: destination)

        controller.tableView.selectRow(at: firstCatIndexPath, animated: false, scrollPosition: .none)

        controller.prepare(for: segue, sender: nil)

        XCTAssertTrue(destination.cat === SampleCat,
                      "The cat representing the selected cell should be set on the destination view controller")
        XCTAssertEqual(destination.navigationItem.title, "SampleCat",
                       "The title of the detail page should be the name of the displayed cat")
    }

    func testPerformSeguePushesDetailController() {
        replaceRootViewController(with: controller)

        let predicateBlock: PredicateBlock = { _, _ in
            self.navController.topViewController is CatDetailController
        }
        expectation(for: NSPredicate(block: predicateBlock), evaluatedWith: self)

        UIViewController.PerformSegueSpyController.createSpy(on: controller)!.spy {
            controller.animals = [SampleCat]

            let cell = controller.tableView.cellForRow(at: firstCatIndexPath) as? CatCell
            controller.performSegue(withIdentifier: "ShowCatDetail", sender: cell)

            waitForExpectations(timeout: 200, handler: nil)

            guard controller.performSegueCalled else {
                return XCTFail("Selecting a cell should trigger a segue")
            }
            XCTAssertEqual(controller.performSegueIdentifier, "ShowCatDetail",
                           "Segue identifier should identify the destination of the segue")
            //XCTAssertTrue(controller.performSegueSender! is FavoritesListController, "Pushed view controller should be a CatDetailController")
        }
    }

}
