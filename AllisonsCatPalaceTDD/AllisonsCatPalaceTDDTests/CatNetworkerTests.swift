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

    func testCreatingRetrieveAllCatsTask() {
        CatNetworker.retrieveAllCats(success: {}, failure: {})

        var potentialTask: URLSessionDataTask?
        CatNetworker.session.getAllTasks { tasks in
            potentialTask = tasks[0] as? URLSessionDataTask
        }
        guard let task = potentialTask else {
            return XCTFail("A task should be created for retrieving all cats")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a cat should be get")
        XCTAssertEqual(request.url?.host, "firebase.com", "The domain should be firebase")
        XCTAssertEqual(request.url?.path, "/cats", "The path should be cats")
    }

    func testNewRetrieveAllCatsTaskCancelsExistingTask() {}
}
