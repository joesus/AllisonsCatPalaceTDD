//
//  DisplayableLocation.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import Foundation

struct DisplayableLocation {

    let displayableString: String

    init(placemark: DisplayablePlacemark) {
        switch (placemark.postalCode, placemark.locality, placemark.administrativeArea) {
        case (nil, nil, nil):
            displayableString = "Unknown"

        case (let postalCode?, nil, nil):
            displayableString = postalCode

        case (nil, let locality?, nil):
            displayableString = locality

        case (nil, nil, let administrativeArea?):
            displayableString = administrativeArea

        case (_, let locality?, let administrativeArea?):
            displayableString = "\(locality), \(administrativeArea)"

        case (let postalCode?, nil, let administrativeArea?):
            displayableString = "\(postalCode) (\(administrativeArea))"

        case (let postalCode?, let locality?, nil):
            displayableString = "\(postalCode) (\(locality))"
        }
    }

}
