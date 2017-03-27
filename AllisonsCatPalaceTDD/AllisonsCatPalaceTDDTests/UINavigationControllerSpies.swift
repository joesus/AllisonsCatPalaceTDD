//
//  UINavigationControllerSpies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/26/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

fileprivate let pushViewControllerWasCalledString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let pushViewControllerWasCalledKey = UnsafeRawPointer(pushViewControllerWasCalledString)

fileprivate let pushedViewControllerString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let pushedViewControllerKey = UnsafeRawPointer(pushedViewControllerString)

fileprivate let pushViewControllerWasAnimatedString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let pushViewControllerWasAnimatedKey = UnsafeRawPointer(pushViewControllerWasAnimatedString)

extension UINavigationController {

    //open func pushViewController(_ viewController: UIViewController, animated: Bool) // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

    var pushViewControllerWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, pushViewControllerWasCalledKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, pushViewControllerWasCalledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var pushedViewController: UIViewController? {
        get {
            let storedValue = objc_getAssociatedObject(self, pushedViewControllerKey)
            return storedValue as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, pushedViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var pushViewControllerWasAnimated: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, pushViewControllerWasAnimatedKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, pushViewControllerWasAnimatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    dynamic func _spyPushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerWasCalled = true
        pushedViewController = viewController
        pushViewControllerWasAnimated = true

        _spyPushViewController(viewController, animated: animated)
    }

    class func beginSpyingOnPushViewController() {
        let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UINavigationController._spyPushViewController(_:animated:)))
    }

    class func endSpyingOnPushViewController() {
        let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UINavigationController._spyPushViewController(_:animated:)))
    }

    override class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = UINavigationController.self
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}
