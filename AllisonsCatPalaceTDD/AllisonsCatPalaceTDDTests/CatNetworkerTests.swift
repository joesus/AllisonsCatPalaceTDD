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

    var taskRetrievalExpectation: XCTestExpectation!

    func testNetworkerSessionIsSharedSession() {
        XCTAssertEqual(CatNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllCatsTask() {
        let potentialTask = getFirstDataTask()

        guard let task = potentialTask else {
            return XCTFail("A task should be created for retrieving all cats")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a cat should be get")
        XCTAssertEqual(request.url?.host, "example.com", "The domain should be firebase")
        XCTAssertEqual(request.url?.path, "/cats", "The path should be cats")
    }

    func testNewRetrieveAllCatsTaskCancelsExistingTask() {}
}

extension CatNetworkerTests {
    func getFirstDataTask() -> URLSessionTask? {
        CatNetworker.retrieveAllCats(success: {_ in})

        var potentialTask: URLSessionTask?
        taskRetrievalExpectation = expectation(description: "Got tasks")
        CatNetworker.session.getAllTasks { [weak self] tasks in
            self?.taskRetrievalExpectation.fulfill()
            if !tasks.isEmpty {
                potentialTask = tasks[0]
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        return potentialTask
    }
}
