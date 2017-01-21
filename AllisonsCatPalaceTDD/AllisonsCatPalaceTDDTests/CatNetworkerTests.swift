//
//  CatNetworkerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class CatNetworkerTests: XCTestCase {
    func testNetworkerSessionIsSharedSession() {
        XCTAssertEqual(CatNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllCatsTask() {}

    func testNewRetrieveAllCatsTaskCancelsExistingTask() {}
}
