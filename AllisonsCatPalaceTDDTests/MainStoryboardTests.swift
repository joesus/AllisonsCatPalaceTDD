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

    func testTopViewControllerIsLocationController() {
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return XCTFail("Initial view controller should be a UINavigationController")
        }

        XCTAssertNotNil(
            navController.topViewController as? LocationController,
            "Top view controller should be a LocationController"
        )
    }

    func testFavoritesListController() {
        let favoritesListController = storyboard.instantiateViewController(withIdentifier: "FavoritesScene")
        XCTAssert(favoritesListController is FavoritesListController, "Should be able to instantiate FavoritesListController from storyboard")
    }

    func testCatDetailViewController() {
        let catDetailController = storyboard.instantiateViewController(withIdentifier: "CatDetailController")
        XCTAssert(catDetailController is CatDetailController, "Should be able to instantiate CatDetailController from storyboard")
    }
}
