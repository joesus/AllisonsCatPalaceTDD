//
//  DisplayablePlacemark.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import CoreLocation

protocol DisplayablePlacemark {
    var postalCode: String? { get }
    var locality: String? { get }
    var administrativeArea: String? { get }
}

extension CLPlacemark: DisplayablePlacemark {}
