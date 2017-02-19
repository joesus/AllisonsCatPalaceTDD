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

    dynamic func _spyReloadData() {
        reloadDataWasCalled = true

        _spyReloadData()
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
