//
//  MainStoryboardTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class MainStoryboardTests: XCTestCase {

    let storyboard = UIStoryboard(
        name: UserInterfaceIdentifiers.StoryboardIdentifiers.main,
        bundle: nil
    )

    func testStoryboardIdentifier() {
        XCTAssertEqual(UserInterfaceIdentifiers.StoryboardIdentifiers.main, "Main",
                       "The main storyboard should be named appropriately")
    }

    func testSceneIdentifiers() {
        XCTAssertEqual(
            UserInterfaceIdentifiers.SceneIdentifiers.locationResolution,
            "LocationResolutionScene",
            "The location resolution scene should have a known identifier"
        )
        XCTAssertEqual(
            UserInterfaceIdentifiers.SceneIdentifiers.favorites,
            "FavoritesScene",
            "The favorites scene should have a known identifier"
        )
        XCTAssertEqual(
            UserInterfaceIdentifiers.SceneIdentifiers.animalDetails,
            "AnimalDetails",
            "The animal details scene should have a known identifier"
        )
        XCTAssertEqual(
            UserInterfaceIdentifiers.SceneIdentifiers.searchResults,
            "SearchResultsScene",
            "The search results scene should have a known identifier"
        )
    }

    func testSegueIdentifiers() {
        XCTAssertEqual(
            UserInterfaceIdentifiers.SegueIdentifiers.showFavorites,
            "ShowFavorites",
            "The show favorites segue should have a known identifier"
        )
    }

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

    func testLocationResolutionScene() {
        let scene = storyboard.instantiateViewController(
            withIdentifier: UserInterfaceIdentifiers.SceneIdentifiers.locationResolution
        )

        XCTAssert(scene is LocationResolutionController,
                  "Should be able to instantiate location resolution scene from storyboard")
    }

    func testFavoritesListController() {
        let favoritesListController = storyboard.instantiateViewController(
            withIdentifier: UserInterfaceIdentifiers.SceneIdentifiers.favorites
        )

        XCTAssert(favoritesListController is FavoritesListController,
                  "Should be able to instantiate FavoritesListController from storyboard")
    }

    func testCatDetailViewController() {
        let catDetailController = storyboard.instantiateViewController(
            withIdentifier: UserInterfaceIdentifiers.SceneIdentifiers.animalDetails
        )

        XCTAssert(catDetailController is CatDetailController,
                  "Should be able to instantiate CatDetailController from storyboard")
    }
}
