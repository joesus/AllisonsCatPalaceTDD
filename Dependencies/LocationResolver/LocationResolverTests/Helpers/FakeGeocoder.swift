//
//  FakeGeocoder.swift
//  LocationResolverTests
//
//  Created by Joe Susnick on 12/2/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import CoreLocation
@testable import LocationResolver

class FakeGeocoder: Geocoding {

    var capturedCompletionHandler: CLGeocodeCompletionHandler?

    var stringToGeocode: String?
    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        stringToGeocode = addressString
        capturedCompletionHandler = completionHandler
    }

    var locationToReverseGeocode: CLLocation?
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        locationToReverseGeocode = location
        capturedCompletionHandler = completionHandler
    }

}
