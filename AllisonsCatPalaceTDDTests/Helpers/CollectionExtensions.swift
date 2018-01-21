//
//  CollectionExtensions.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 1/20/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import Foundation

extension Collection {
    var onlyElement: Element? {
        guard count == 1 else {
            return nil
        }

        return first
    }
}
