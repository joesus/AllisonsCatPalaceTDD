// swiftlint:disable identifier_name
//
//  UIViewControllerSpies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

private let viewDidLoadString = NSUUID().uuidString.cString(using: .utf8)!
private let viewDidLoadKey = UnsafeRawPointer(viewDidLoadString)

extension UIViewController {
    var viewDidLoadWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, viewDidLoadKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, viewDidLoadKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    dynamic func _spyViewDidLoad() {
        viewDidLoadWasCalled = true

        _spyViewDidLoad()
    }

    class func beginSpyingOnViewDidLoad() {
        let originalSelector = #selector(UIViewController.viewDidLoad)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UIViewController._spyViewDidLoad))
    }

    class func endSpyingOnViewDidLoad() {
        let originalSelector = #selector(UIViewController.viewDidLoad)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UIViewController._spyViewDidLoad))
    }

    class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = UIViewController.self
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}
