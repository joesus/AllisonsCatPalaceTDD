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
    var tableView: UITableView!
    let firstCatIndexPath = IndexPath(row: 0, section: 0)

    override func setUp() {
        super.setUp()

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        replaceRootViewController(with: navController) // the main controller for the window is now the navController
        
        controller = navController.topViewController as! CatListController
        tableView = controller.tableView
        UITableView.beginSpyingOnReloadData()
    }

    override func tearDown() {
        UITableView.endSpyingOnReloadData()
        restoreRootViewController()

        super.tearDown()
    }

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "CatListController should be a UITableViewController")
    }

    func testHasNoCatsByDefault() {
        XCTAssert(controller.cats.isEmpty, "CatListController should have no cats by default")
    }

    func testViewDidLoadCallsSuperViewDidLoad() {
        UITableViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            controller.viewDidLoad()
            XCTAssert(controller.superclassViewDidLoadCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        }
    }

    // TODO: - figure out how to test that the registry was called.
    //    func testRequestsCatsOnViewDidLoad() { }

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
        XCTAssert(tableView.reloadDataWasCalled,
                  "TableView should be reloaded when cats are updated")
        XCTAssert(tableView.reloadDataCalledOnMainThread!,
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
        
        let predicateBlock: PredicateBlock = { _, _ in
            self.navController.topViewController is CatDetailController
        }
        expectation(for: NSPredicate(block: predicateBlock), evaluatedWith: self)
        
//        UINavigationController.ShowSpyController.createSpy(on: navController)!.spy {
            controller.cats = [SampleCat]

            //controller.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            //controller.tableView.delegate?.tableView!(controller.tableView, didSelectRowAt: IndexPath(row:0, section:0))

            controller.tableView.selectRow(at: firstCatIndexPath, animated: false, scrollPosition: .none)
            
            waitForExpectations(timeout: 2, handler: nil)
            
            XCTAssertTrue(navController.showCalled, "Selecting a cell should trigger a segue")
            XCTAssertTrue(navController.topViewController! is CatDetailController, "Pushed view controller should be a CatDetailController")
//        }
    }

//    func testPrepareForSegue() {
//        UINavigationController.PushViewControllerSpyController.createSpy(on: navController)!.spy {
//            controller.cats = [SampleCat]
////            let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: firstCatIndexPath) as? CatCell
////            tableView.selectRow(at: firstCatIndexPath, animated: false, scrollPosition: .none)
////            controller.performSegue(withIdentifier: "ShowCatDetail", sender: cell)
//
//            controller.tableView(tableView, didSelectRowAt: firstCatIndexPath)
//
//            guard let catDetailController = navController.pushedController as? CatDetailController else {
//                return XCTFail("PerformSegue should present a CatDetailController")
//            }
//
//            XCTAssertTrue(catDetailController.cat === SampleCat,
//                          "The cat representing the selected cell should be set on the destination view controller")
//            XCTAssertEqual(catDetailController.navigationItem.title, "SampleCat",
//                           "The title of the detail page should be the name of the displayed cat")
//        }
//    }
}






