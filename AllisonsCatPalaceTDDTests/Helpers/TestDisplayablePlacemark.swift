//
//  TestDisplayablePlacemark.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD

struct TestDisplayablePlacemark: DisplayablePlacemark {
    var postalCode: String?
    var locality: String?
    var administrativeArea: String?

    init(
        postalCode: String? = nil,
        locality: String? = nil,
        administrativeArea: String? = nil
        ) {

        self.postalCode = postalCode
        self.locality = locality
        self.administrativeArea = administrativeArea
    }
}
