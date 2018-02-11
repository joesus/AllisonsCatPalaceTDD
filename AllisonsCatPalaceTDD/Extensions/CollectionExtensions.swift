//
//  CollectionExtensions.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 2/11/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import Foundation

extension Collection {

    func element(at index: Index) -> Iterator.Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }

}
