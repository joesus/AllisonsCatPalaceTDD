//
//  URLSessionSpies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

typealias NetworkTaskCompletionHandler = ((Data?, URLResponse?, Error?) -> Void)

fileprivate let lastResumedDataTaskString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let lastResumedDataTaskKey = UnsafeRawPointer(lastResumedDataTaskString)

fileprivate let capturedRequestURLString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let capturedRequestURLKey = UnsafeRawPointer(capturedRequestURLString)

fileprivate let capturedCompletionHandlerString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let capturedCompletionHandlerKey = UnsafeRawPointer(capturedCompletionHandlerString)

fileprivate let lastCreatedDataTaskString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let lastCreatedDataTaskKey = UnsafeRawPointer(lastCreatedDataTaskString)


extension URLSession {
    var lastResumedDataTask: URLSessionTask? {
        get {
            let storedValue = objc_getAssociatedObject(self, lastResumedDataTaskKey)
            return storedValue as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, lastResumedDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var lastCreatedDataTask: URLSessionTask? {
        get {
            let storedValue = objc_getAssociatedObject(self, lastCreatedDataTaskKey)
            return storedValue as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, lastCreatedDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var capturedRequestURL: URL? {
        get {
            let storedValue = objc_getAssociatedObject(self, capturedRequestURLKey)
            return storedValue as? URL
        }
        set {
            objc_setAssociatedObject(self, capturedRequestURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var capturedCompletionHandler: Box<NetworkTaskCompletionHandler>? {
        get {
            let storedValue = objc_getAssociatedObject(self, capturedCompletionHandlerKey)
            return storedValue as? Box<NetworkTaskCompletionHandler>
        }
        set {
            objc_setAssociatedObject(self, capturedCompletionHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    dynamic func _spyDataTaskCreation(with url: URL, completionHandler: @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask {

        //TODO: Need to capture url, completionHandler
        capturedRequestURL = url
        capturedCompletionHandler = Box(completionHandler)

        // This is now the real method that it forwards to
        let task = _spyDataTaskCreation(with: url, completionHandler: completionHandler)
        CatNetworker.session.lastCreatedDataTask = task

        return task
    }

    class func beginSpyingOnDataTaskCreation() {
//        open func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask

        let originalSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(URLSession._spyDataTaskCreation(with:completionHandler:)))
    }

    class func endSpyingOnDataTaskCreation() {
        let originalSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(URLSession._spyDataTaskCreation(with:completionHandler:)))
    }

    class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = URLSession.self
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}
