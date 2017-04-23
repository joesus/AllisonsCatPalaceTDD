//
//  CatListControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/12/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import TestableUIKit
@testable import AllisonsCatPalaceTDD

class CatListControllerTests: XCTestCase {

    var controller: CatListController!
    var navController: UINavigationController!

    override func setUp() {
        super.setUp()


        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        controller = navController.topViewController as! CatListController
        UITableView.beginSpyingOnReloadData()
    }

    override func tearDown() {
        UITableView.endSpyingOnReloadData()

        super.tearDown()
    }

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
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataWasCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        DispatchQueue.global(qos: .background).async { [weak controller] in
            let cat = Cat(name: "Test", identifier: 1)
            controller?.cats.append(cat)
        }

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(controller.tableView.reloadDataWasCalled,
                  "TableView should be reloaded when cats are updated")
        XCTAssert(controller.tableView.reloadDataCalledOnMainThread!,
                  "Reload data should be called on the main thread when cats are updated on a background thread")
    }

    func testReloadDataIsCalledWhenCatsAreCleared() {
        let reloadedPredicate = NSPredicate { [controller] _,_ in
            controller!.tableView.reloadDataWasCalled
        }
        expectation(for: reloadedPredicate, evaluatedWith: [:], handler: nil)

        DispatchQueue.global(qos: .background).async { [weak controller] in
            controller?.cats = []
        }

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(controller.tableView.reloadDataWasCalled, "TableView should be reloaded when cats are cleared")
        XCTAssert(controller.tableView.reloadDataCalledOnMainThread!,
                  "Reload data should be called on the main thread when cats are cleared on a background thread")
    }

    // TODO: - not sure this is a viable way to test push segues from a tableview. Also would love to be able to test unnamed segues since there's not a good reason aside from testing that this segue needs to be named
    func testSelectingCellPushesDetailController() {
        UINavigationController.PushViewControllerSpyController.createSpy(on: navController)!.spy {
            controller.cats = [SampleCat]

            //controller.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            //controller.tableView.delegate?.tableView!(controller.tableView, didSelectRowAt: IndexPath(row:0, section:0))

            let cell = controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            controller.performSegue(withIdentifier: "ShowCatDetail", sender: cell)

            XCTAssertTrue(navController.pushViewControllerCalled, "Selecting a cell should trigger a segue")
            XCTAssertTrue(navController.pushedController! is CatDetailController, "Pushed view controller should be a CatDetailController")
        }
    }

    func testPrepareForSegue() {
        // sets cat
        // sets nav title
    }
}






