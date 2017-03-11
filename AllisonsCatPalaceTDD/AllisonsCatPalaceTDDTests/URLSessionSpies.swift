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

fileprivate let capturedRequestString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let capturedRequestKey = UnsafeRawPointer(capturedRequestString)

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


    var capturedRequest: URLRequest? {
        get {
            let storedValue = objc_getAssociatedObject(self, capturedRequestKey)
            return storedValue as? URLRequest
        }
        set {
            objc_setAssociatedObject(self, capturedRequestKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var capturedCompletionHandler: NetworkTaskCompletionHandler? {
        get {
            let storedValue = objc_getAssociatedObject(self, capturedCompletionHandlerKey) as? Box<NetworkTaskCompletionHandler>
            return storedValue?.unbox()
        }
        set {
            guard let handler = newValue else {
                return objc_setAssociatedObject(self, capturedCompletionHandlerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }

            objc_setAssociatedObject(self, capturedCompletionHandlerKey, Box(handler), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    dynamic func _spyDataTaskCreationRequest(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {

        capturedRequest = request
        capturedCompletionHandler = completionHandler

        // This is now the real method that it forwards to
        let task = _spyDataTaskCreationRequest(with: request, completionHandler: completionHandler)
        URLSession.shared.lastCreatedDataTask = task

        return task

    }

    dynamic func _spyDataTaskCreation(with url: URL, completionHandler: @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask {

        capturedRequestURL = url
        capturedCompletionHandler = completionHandler

        // This is now the real method that it forwards to
        let task = _spyDataTaskCreation(with: url, completionHandler: completionHandler)
        URLSession.shared.lastCreatedDataTask = task

        return task
    }

    class func beginSpyingOnDataTaskCreation() {
        let originalSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(URLSession._spyDataTaskCreation(with:completionHandler:)))

        // The Request Version
        let originalWithRequestSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalWithRequestSelector, alternateSelector: #selector(URLSession._spyDataTaskCreationRequest(with:completionHandler:)))
    }

    class func endSpyingOnDataTaskCreation() {
        let originalSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(URLSession._spyDataTaskCreation(with:completionHandler:)))

        // The Request Version
        let originalWithRequestSelector = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping NetworkTaskCompletionHandler) -> URLSessionDataTask)

        swapMethods(originalSelector: originalWithRequestSelector, alternateSelector: #selector(URLSession._spyDataTaskCreationRequest(with:completionHandler:)))
    }

    class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = URLSession.self
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}
