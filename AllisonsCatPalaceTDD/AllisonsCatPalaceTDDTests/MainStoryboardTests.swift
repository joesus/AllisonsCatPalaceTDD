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

    func testRootViewControllerIsCatListController() {
        guard let rootViewController = storyboard.instantiateInitialViewController() else {
            return XCTFail("There should be an initial view controller on the storyboard")
        }

        XCTAssert(rootViewController is CatListController, "RootViewController should be a Cat List Controller")
    }

    func testCatDetailViewController() {
        let catDetailController = storyboard.instantiateViewController(withIdentifier: "CatDetail")
        XCTAssert(catDetailController is CatDetailTableViewController, "Should be able to instantiate CatDetailTableViewController from storyboard")
    }
}
