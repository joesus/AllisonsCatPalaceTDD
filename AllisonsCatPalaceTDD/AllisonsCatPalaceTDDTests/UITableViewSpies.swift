//
//  UITableViewSpies.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/19/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

fileprivate let reloadDataString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let reloadDataKey = UnsafeRawPointer(reloadDataString)

fileprivate let reloadRowsCalledString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let reloadRowsCalledKey = UnsafeRawPointer(reloadRowsCalledString)

fileprivate let reloadRowsIndexPathsString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let reloadRowsIndexPathsKey = UnsafeRawPointer(reloadRowsIndexPathsString)

fileprivate let reloadRowsAnimationString = NSUUID().uuidString.cString(using: .utf8)!
fileprivate let reloadRowsAnimationKey = UnsafeRawPointer(reloadRowsAnimationString)

extension UITableView {
    var reloadDataWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, reloadDataKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, reloadDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var reloadRowsWasCalled: Bool {
        get {
            let storedValue = objc_getAssociatedObject(self, reloadRowsCalledKey)
            return storedValue as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, reloadRowsCalledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var reloadRowsIndexPaths: [IndexPath]? {
        get {
            let storedValue = objc_getAssociatedObject(self, reloadRowsIndexPathsKey)
            return storedValue as? [IndexPath]
        }
        set {
            objc_setAssociatedObject(self, reloadRowsIndexPathsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var reloadRowsAnimation: UITableViewRowAnimation? {
        get {
            let storedValue = objc_getAssociatedObject(self, reloadRowsAnimationKey)
            return storedValue as? UITableViewRowAnimation
        }
        set {
            objc_setAssociatedObject(self, reloadRowsAnimationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    dynamic func _spyReloadData() {
        reloadDataWasCalled = true

        _spyReloadData()
    }

    dynamic func _spyReloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        reloadRowsWasCalled = true
        reloadRowsIndexPaths = indexPaths
        reloadRowsAnimation = animation

        _spyReloadRows(at: indexPaths, with: animation)
    }

    class func beginSpyingOnReloadRows() {
        let originalSelector = #selector(UITableView.reloadRows(at:with:))

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UITableView._spyReloadRows(at:with:)))
    }

    class func endSpyingOnReloadRows() {
        let originalSelector = #selector(UITableView.reloadRows(at:with:))

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UITableView._spyReloadRows(at:with:)))
    }

    class func beginSpyingOnReloadData() {
        let originalSelector = #selector(UITableView.reloadData)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UITableView._spyReloadData))
    }

    class func endSpyingOnReloadData() {
        let originalSelector = #selector(UITableView.reloadData)

        swapMethods(originalSelector: originalSelector, alternateSelector: #selector(UITableView._spyReloadData))
    }

    class func swapMethods(originalSelector: Selector, alternateSelector: Selector) {
        let type: AnyClass = UITableView.self
        let originalMethod = class_getInstanceMethod(type, originalSelector)
        let alternateMethod = class_getInstanceMethod(type, alternateSelector)

        method_exchangeImplementations(originalMethod, alternateMethod)
    }
}
