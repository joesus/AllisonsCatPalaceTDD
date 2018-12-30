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

    var geocodeAddressStringCallCount = 0
    var stringToGeocode: String?
    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        stringToGeocode = addressString
        capturedCompletionHandler = completionHandler
        geocodeAddressStringCallCount += 1
    }

    var locationToReverseGeocode: CLLocation?
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        locationToReverseGeocode = location
        capturedCompletionHandler = completionHandler
    }

}
