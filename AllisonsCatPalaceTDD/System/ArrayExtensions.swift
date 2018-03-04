// swiftlint:disable syntactic_sugar
//
//  ArrayExtensions.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removingDuplicates() -> Array<Element> {
        var withoutDuplicates = [Element]()

        forEach { item in
            if !withoutDuplicates.contains(item) {
                withoutDuplicates.append(item)
            }
        }

        return withoutDuplicates
    }
}

extension Array where Element == URL {
    func removingDuplicates() -> Array<Element> {
        var withoutDuplicates = [Element]()

        forEach { item in
            let standardized = item.standardized
            if !withoutDuplicates.contains(standardized) {
                withoutDuplicates.append(standardized)
            }
        }

        return withoutDuplicates
    }
}
