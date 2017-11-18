//
//  URLSessionDataTaskSpies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

// MARK: - Keys for associated objects
fileprivate let resumeWasCalledUniqueString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let resumeWasCalledKey = UnsafeRawPointer(resumeWasCalledUniqueString)

fileprivate let cancelWasCalledString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let cancelWasCalledKey = UnsafeRawPointer(cancelWasCalledString)

// MARK: - URLSessionTask extension for spying on resume()
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
        URLSession.shared.lastResumedDataTask = self
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
