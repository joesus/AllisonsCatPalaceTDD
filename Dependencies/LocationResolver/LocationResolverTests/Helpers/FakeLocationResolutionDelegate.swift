//
//  FakeLocationResolutionDelegate.swift
//  LocationResolverTests
//
//  Created by Joe Susnick on 12/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import LocationResolving

class FakeLocationResolutionDelegate: LocationResolutionDelegate {

    var capturedLocationResolution: LocationResolution?
    func didResolveLocation(_ location: LocationResolution) {
        capturedLocationResolution = location
    }

}
