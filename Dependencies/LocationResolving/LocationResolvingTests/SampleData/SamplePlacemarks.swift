//
//  SamplePlacemarks.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation

enum SamplePlacemarks {
    static let denver = loadPlacemark(named: "DenverPlacemark")
    static let vancouver = loadPlacemark(named: "VancouverPlacemark")

    static func loadPlacemark(named filename: String) -> CLPlacemark {
        guard let url = Bundle(for: LocationResolutionTests.self)
            .url(forResource: filename, withExtension: nil),
            let placemark = NSKeyedUnarchiver.unarchiveObject(withFile: url.path)
                as? CLPlacemark
            else {
                fatalError("A sample placemark is required")
        }

        return placemark
    }
}
