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

    override func setUp() {
        super.setUp()

        URLSessionTask.beginSpyingOnResume()
    }

    override func tearDown() {
        URLSessionTask.endSpyingOnResume()

        super.tearDown()
    }

    func testNetworkerSessionIsSharedSession() {
        XCTAssertEqual(CatNetworker.session, URLSession.shared, "Networker should be using the shared session")
    }

    func testCreatingRetrieveAllCatsTask() {
        CatNetworker.retrieveAllCats(success: {_ in})

        guard let task = URLSession.lastResumedDataTask else {
            return XCTFail("A task should have been created")
        }

        guard let request = task.currentRequest else {
            return XCTFail("A task should have a currentRequest")
        }

        XCTAssertEqual(request.httpMethod, "GET", "The request method for retrieving a cat should be get")
        XCTAssertEqual(request.url?.host, "example.com", "The domain should be firebase")
        XCTAssertEqual(request.url?.path, "/cats", "The path should be cats")
        XCTAssert(task.resumeWasCalled, "task should be started")

        // Cleanup of sorts
        task.resumeWasCalled = false
    }

    func testNewRetrieveAllCatsTaskCancelsExistingTask() {
        CatNetworker.retrieveAllCats(success: {_ in})

        guard let firstTask = URLSession.lastResumedDataTask else {
            fatalError("A task should have been created")
        }
        CatNetworker.retrieveAllCats(success: {_ in})
        XCTAssertTrue(firstTask.cancelWasCalled, "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }
}

extension CatNetworkerTests {

    func hasDataTask() -> Bool {
        var hasTasks = false

        CatNetworker.session.getAllTasks { tasks in
            hasTasks = !tasks.isEmpty
        }
        return hasTasks
    }
}

//MARK: - Keys for associated objects
fileprivate let resumeWasCalledUniqueString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let resumeWasCalledKey = UnsafeRawPointer(resumeWasCalledUniqueString)

fileprivate let lastResumedDataTaskString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let lastResumedDataTaskKey = UnsafeRawPointer(lastResumedDataTaskString)

fileprivate let cancelWasCalledString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let cancelWasCalledKey = UnsafeRawPointer(cancelWasCalledString)

//MARK: - URLSession extension for associated objects
// This is just to be able to access the task
extension URLSession {
    class var lastResumedDataTask: URLSessionTask? {
        get {
            let storedValue = objc_getAssociatedObject(self, lastResumedDataTaskKey)
            return storedValue as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, lastResumedDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

//MARK: - URLSessionTask extension for spying on resume()
extension URLSessionTask {

    var cancelWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, cancelWasCalledKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, cancelWasCalledKey, true, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    var resumeWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, resumeWasCalledKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, resumeWasCalledKey, true, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    // This is the magical part, setting the associated objects to make sure everything is in the right place
    dynamic func _spyResume() {
        URLSession.lastResumedDataTask = self
        resumeWasCalled = true
    }

    class func beginSpyingOnResume() {
        swapMethods(originalSelector: #selector(URLSessionTask.resume), alternateSelector: #selector(URLSessionTask._spyResume))
    }

    class func endSpyingOnResume() {
        swapMethods(originalSelector: #selector(URLSessionTask.resume), alternateSelector: #selector(URLSessionTask._spyResume))
    }

    dynamic func _spyCancel() {
        cancelWasCalled = true
    }

    class func beginSpyingOnCancel() {
        swapMethods(originalSelector: #selector(URLSessionTask.cancel), alternateSelector: #selector(URLSessionTask._spyCancel))
    }

    class func endSpyingOnCancel() {
        swapMethods(originalSelector: #selector(URLSessionTask.cancel), alternateSelector: #selector(URLSessionTask._spyCancel))
    }


    class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = objc_getClass("__NSCFLocalDataTask") as! AnyClass
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}


