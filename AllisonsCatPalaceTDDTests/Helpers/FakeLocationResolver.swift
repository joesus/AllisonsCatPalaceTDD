//
//  FakeLocationResolver.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/8/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import LocationResolving
import CoreLocation // TODO:- may be able to remove

class FakeLocationResolver: LocationResolving {
    weak var delegate: LocationResolutionDelegate?

    var locationResolution: LocationResolution?
    var userLocationResolvability: UserLocationResolvability = .allowed

    var requestedAvailability: UserLocationUpdateAvailability?
    func requestUserLocationAuthorization(for availability: UserLocationUpdateAvailability) {
        requestedAvailability = availability
    }

    var resolveUserLocationCallCount = 0
    func resolveUserLocation() {
        resolveUserLocationCallCount += 1
    }
    func resolveLocation(for: String) {}
}
