//
//  MainStoryboardTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class MainStoryboardTests: XCTestCase {

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

    func testInitialViewControllerIsNavigationController() {
        let initialViewController = storyboard.instantiateInitialViewController() as? UINavigationController

        XCTAssertNotNil(initialViewController, "initialViewController should be a UINavigationController")
    }

    func testTopViewControllerIsCatListController() {
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return XCTFail("Initial view controller should be a UINavigationController")
        }
        let topViewController = navController.topViewController as? CatListController

        XCTAssertNotNil(topViewController, "Top view controller should be a CatListController")
    }

    func testCatDetailViewController() {
        let catDetailController = storyboard.instantiateViewController(withIdentifier: "CatDetail")
        XCTAssert(catDetailController is CatDetailController, "Should be able to instantiate CatDetailController from storyboard")
    }
}
