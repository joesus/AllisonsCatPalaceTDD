//
//  UserLocationResolution.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation

public enum UserLocationResolution: Equatable {
    case unknown
    case allowed
    case disallowed
    case resolving
    case resolved(placemark: CLPlacemark)
    case resolutionFailed(error: LocationResolutionError)

    public var error: LocationResolutionError? {
        guard case .resolutionFailed(let error) = self else {
            return nil
        }

        return error
    }

    public var placemark: CLPlacemark? {
        guard case .resolved(let placemark) = self else {
            return nil
        }

        return placemark
    }
}
