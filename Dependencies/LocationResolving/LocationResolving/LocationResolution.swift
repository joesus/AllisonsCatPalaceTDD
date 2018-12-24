//
//  LocationResolution.swift
//  LocationResolving
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation

public enum LocationResolution: Equatable {
    case resolved(placemark: CLPlacemark, date: Date)
    case resolutionFailed(error: LocationResolutionError, date: Date)

    public var error: LocationResolutionError? {
        guard case .resolutionFailed(let error, _) = self else {
            return nil
        }

        return error
    }

    public var placemark: CLPlacemark? {
        guard case .resolved(let placemark, _) = self else {
            return nil
        }

        return placemark
    }

    public var date: Date {
        switch self {
        case .resolved(_, let date): return date
        case .resolutionFailed(_, let date): return date
        }
    }
}
