//
//  SpeciesSelectionControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 9/6/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class SpeciesSelectionControllerTests: XCTestCase {

    var navController: UINavigationController!
    var controller: SpeciesSelectionController!

    override func setUp() {
        super.setUp()

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController

        replaceRootViewController(with: navController) // the main controller for the window is now the navController

        guard let speciesController = UIStoryboard(name: "Main", bundle: Bundle(for: SpeciesSelectionController.self)).instantiateViewController(withIdentifier: "SpeciesSelectionController") as? SpeciesSelectionController else {
            return XCTFail("Main storyboard should have a species selection controller")
        }

        navController.addChildViewController(speciesController)

        controller = navController.topViewController as! SpeciesSelectionController
        controller.loadViewIfNeeded()

        SettingsManager.shared.clear()
    }

    func testButtons() {
        XCTAssertNotNil(controller.catsButton.backgroundImage(for: .normal),
                        "Cats button should have an image set")
        XCTAssertNotNil(controller.dogsButton.backgroundImage(for: .normal),
                        "Dogs button should have an image set")
        XCTAssertNotNil(controller.anyButton.backgroundImage(for: .normal),
                        "`Any` button should have an image set")
    }

    func testSelectingCatsUpdatesSettings() {
        XCTAssertNil(SettingsManager.shared.value(forKey: .species))

        controller.speciesTapped(controller.catsButton)

        XCTAssertEqual(SettingsManager.shared.value(forKey: .species) as? String, AnimalSpecies.cat.rawValue,
                       "Cats button should update settings to specify cat as the species to search for")
    }

    func testSelectingDogsUpdatesSettings() {
        XCTAssertNil(SettingsManager.shared.value(forKey: .species))

        controller.speciesTapped(controller.dogsButton)

        XCTAssertEqual(SettingsManager.shared.value(forKey: .species) as? String, AnimalSpecies.dog.rawValue,
                       "Dogs button should update settings to specify dog as the species to search for")
    }

    func testSelectingOtherUpdatesSettings() {
        XCTAssertNil(SettingsManager.shared.value(forKey: .species))

        controller.speciesTapped(controller.anyButton)

        XCTAssertNil(SettingsManager.shared.value(forKey: .species),
                     "`Any` button should update settings to not specify a species")
    }

    func testPerformSeguePushesDetailController() {
        replaceRootViewController(with: controller)

        let predicateBlock: PredicateBlock = { _, _ in
            self.navController.topViewController is LocationController //Correct controller was pushed onto the nav controller
        }
        expectation(for: NSPredicate(block: predicateBlock), evaluatedWith: self)

        UIViewController.PerformSegueSpyController.createSpy(on: controller)!.spy {

            controller.performSegue(withIdentifier: "ShowLocationController", sender: nil)

            waitForExpectations(timeout: 2, handler: nil)

            guard controller.performSegueCalled else {
                return XCTFail("Should have performed segue")
            }
            XCTAssertEqual(controller.performSegueIdentifier, "ShowLocationController",
                           "Segue identifier should identify the destination of the segue")
        }
    }

    func testFavoritesButton() {
        XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Favorites",
                       "Favorites button exists and has correct title")
    }

    func testFavoritesSegue() {
        guard let navController = UIStoryboard(name: "Main", bundle: Bundle(for: AnimalCardsViewController.self)).instantiateInitialViewController() as? UINavigationController else {
            return XCTFail("Main storyboard should have a navigation controller")
        }

        replaceRootViewController(with: navController) // add it to the window
        navController.addChildViewController(controller) // make controller the top view controller

        let predicate = NSPredicate { _, _ in
            navController.topViewController is FavoritesListController
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        UIViewController.PerformSegueSpyController.createSpy(on: controller)!.spy {
            controller.performSegue(withIdentifier: "showFavoritesListController", sender: controller.navigationItem.rightBarButtonItem)

            waitForExpectations(timeout: 2, handler: nil)

            XCTAssertTrue(controller.performSegueCalled,
                          "Perform segue should be called on controller")
            XCTAssertEqual(controller.performSegueIdentifier, "showFavoritesListController",
                           "Segue identifier should identify the destination of the segue")
        }
    }

}
