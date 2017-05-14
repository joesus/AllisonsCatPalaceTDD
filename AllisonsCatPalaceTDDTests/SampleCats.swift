//
//  SampleCats.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
@testable import AllisonsCatPalaceTDD

let SampleCat = Cat(name: "SampleCat", identifier: 1)

let cats: [Cat] = (1...100).map { integer in
    let url = URL(string: "http://example.com/image\(integer).jpg")!
    return Cat(name: "test", identifier: integer, imageUrl: url)
}
