//
//  Cat.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class Cat {

    var name: String
    let identifier: Int
    let url: URL?

    init(name: String, identifier: Int, url: URL? = nil) {
        self.name = name
        self.identifier = identifier
        self.url = url
    }

}
