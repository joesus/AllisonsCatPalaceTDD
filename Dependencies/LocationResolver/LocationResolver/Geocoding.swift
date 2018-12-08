//
//  Geocoding.swift
//  LocationResolver
//
//  Created by Joe Susnick on 12/2/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation

protocol Geocoding {
    func reverseGeocodeLocation(
        _ location: CLLocation,
        completionHandler: @escaping CLGeocodeCompletionHandler
    )

    func geocodeAddressString(
        _ addressString: String,
        completionHandler: @escaping CLGeocodeCompletionHandler
    )
}

extension CLGeocoder: Geocoding {}
