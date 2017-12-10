//
//  UserLocationResolution.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation

enum UserLocationResolution {
    case resolved(location: CLPlacemark)
    case resolving
    case resolutionFailure(error: Error)
    case blocked
    case geocodeFailure(error: Error)
}
