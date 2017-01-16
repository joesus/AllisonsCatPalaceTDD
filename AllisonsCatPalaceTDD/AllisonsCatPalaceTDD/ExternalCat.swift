//
//  ExternalCat.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct ExternalCat {
    let name: String?
    let identifier: Int?
}

extension ExternalCat {

    enum ServerKeys {
        static let name = "name"
        static let id = "id"
    }
}
