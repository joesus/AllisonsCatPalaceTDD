//
//  AppDelegateTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class AppDelegateTests: XCTestCase {

    let application = UIApplication.shared
    var delegate: UIApplicationDelegate!

    override func setUp() {
        super.setUp()

        delegate = application.delegate
    }

    func testAppDelegateIsCorrectType() {
        guard let appDelegate = delegate else {
            return XCTFail("Missing Delegate")
        }

        XCTAssertTrue(appDelegate is AppDelegate, "appDelegate is incorrect class")
    }

    func testAppDelegateHasWindow() {
        XCTAssertNotNil(delegate.window as Any, "window must not be nil")
    }

    func testDidFinishLaunchingReturnsTrue() {
        let returnValue = delegate.application?(application, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(returnValue!, "application(didFinishLaunchingWithOptions) should return true")
    }
}
