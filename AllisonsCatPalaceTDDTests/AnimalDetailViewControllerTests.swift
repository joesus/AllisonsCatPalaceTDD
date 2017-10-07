//
//  CatDetailViewControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/26/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
import TestableUIKit
@testable import AllisonsCatPalaceTDD

class CatDetailViewControllerTests: XCTestCase {

    var controller: CatDetailController!
    var header: AnimalDetailHeaderView!

    override func setUp() {
        super.setUp()

        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CatDetailController") as! CatDetailController
        header = controller.tableView.tableHeaderView as? AnimalDetailHeaderView
    }

    func testIsTableViewController() {
        XCTAssert(controller as Any is UITableViewController, "CatListController should be a UITableViewController")
    }

    func testDoesNotHaveCatByDefault() {
        XCTAssertNil(controller.cat, "Should not have a cat unless specified")
    }

    // TODO:- Make sure the other view lifecycle methods are protected
    func testViewDidLoadCallsSuperViewDidLoad() {
        UIViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            controller.viewDidLoad()
            XCTAssert(controller.superclassViewDidLoadCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        }
    }

    func testReloadDataIsNotCalledWhenCatChangeNotAllowed() {
        controller.cat = cats[0]
        UITableView.ReloadDataSpyController.createSpy(on: controller.tableView)!.spy {
            controller.cat = nil
            XCTAssertFalse(controller.tableView.reloadDataCalled, "Reload data should not be called when change to cat is blocked")
            controller.cat = cats[1]
            XCTAssertFalse(controller.tableView.reloadDataCalled, "Reload data should not be called when change to cat is blocked")
        }
    }

    func testReloadDataIsCalledWhenCatIsUpdated() {
        UITableView.ReloadDataSpyController.createSpy(on: controller.tableView)!.spy {
            controller.cat = SampleCat
            XCTAssertTrue(controller.tableView.reloadDataCalled, "Tableview should reload data when cat is updated")
        }
    }

    func testAlwaysHasOneSection() {
        XCTAssertEqual(controller.tableView.numberOfSections, 1, "Detail view tableview should always have one section")
        controller.cat = SampleCat
        XCTAssertEqual(controller.tableView.numberOfSections, 1, "Detail view tableview should always have one section")
    }

    func testCatCanOnlyBeSetOnce() {
        controller.cat = cats[0]
        controller.cat = nil
        XCTAssertEqual(controller.cat?.identifier, 1, "Cat should not be resettable")
        controller.cat = cats[1]
        XCTAssertEqual(controller.cat?.identifier, 1, "Should not be able to change cat once it is set")
    }

    func testFirstSectionHasCustomTableHeaderView() {
        XCTAssertNotNil(header, "Tableview should have a custom tableHeaderView")
    }

    func testHeaderHasImageViewWithDefaultImage() {
        guard let headerContentView = header.subviews.first,
            let imageView = header.imageView else {
            return XCTFail("Header should have an image view")
        }

        XCTAssertEqual(imageView.image, #imageLiteral(resourceName: "catOutline"), "Imageview should have a default image")

        // TESTING CONSTRAINTS
        let constraints = headerContentView.constraints.filter { constraint in
            constraint.firstItem === imageView && constraint.secondItem === headerContentView ||
            constraint.firstItem === headerContentView && constraint.secondItem === imageView
        }

        XCTAssertEqual(constraints.count, 4, "Imageview should be constrained to header content view on four sides")
        constraints.forEach { constraint in
            XCTAssertEqual(constraint.constant, 0, "All sides should be constrained with a constant of zero")
            XCTAssertEqual(constraint.multiplier, 1, "All multipliers should be 1")
        }

        guard let leading = constraints.first(where: { constraint in
            constraint.firstAttribute == .leading }),
            leading.secondAttribute == .leading else {
            return XCTFail("Imageview should be pinned to leading edge of header")
        }
        guard let trailing = constraints.first(where: { constraint in
            constraint.firstAttribute == .trailing }),
            trailing.secondAttribute == .trailing else {
                return XCTFail("Imageview should be pinned to trailing edge of header")
        }
        guard let top = constraints.first(where: { constraint in
            constraint.firstAttribute == .top }),
            top.secondAttribute == .top else {
                return XCTFail("Imageview should be pinned to top edge of header")
        }
        guard let bottom = constraints.first(where: { constraint in
            constraint.firstAttribute == .bottom }),
            bottom.secondAttribute == .bottom else {
                return XCTFail("Imageview should be pinned to bottom edge of header")
        }

    }

    func testControllerHasOutletForHeaderView() {
        controller.loadViewIfNeeded()

        XCTAssertNotNil(controller.headerView,
                        "Controller should have an outlet to an animal detail header view")
    }

    func testViewDidLoadCallsSuper() {
        UIViewController.ViewDidLoadSpyController.createSpy(on: controller)?.spy {
            controller.viewDidLoad()

            XCTAssertTrue(controller.superclassViewDidLoadCalled,
                          "controller should call superclass view did load")
        }
    }

    func testSetsAnimalToHeaderIfHeaderHasNoAnimal() {
        controller.loadViewIfNeeded()
        XCTAssertNil(controller.headerView.animal,
                     "Header view should have no animal by default")

        controller.cat = cats.first!
        XCTAssertNil(controller.headerView.animal,
                     "setting animal on controller should not set animal on header view")

        controller.viewDidLoad()
        XCTAssertTrue(controller.headerView.animal === controller.cat,
                      "Controller should pass animal to header view on viewDidLoad")
    }

    func testDoesNotSetAnimalOnHeaderIfHeaderHasAnimal() {
        controller.loadViewIfNeeded()
        XCTAssertNil(controller.headerView.animal,
                     "Header view should have no animal by default")
        controller.cat = cats.first!
        XCTAssertNil(controller.headerView.animal,
                     "setting animal on controller should not set animal on header view")

        controller.headerView.animal = cats[1]
        controller.viewDidLoad()

        XCTAssertFalse(controller.headerView.animal === controller.cat,
                      "Controller should not pass animal to header view if header view already has an animal")
    }
}



