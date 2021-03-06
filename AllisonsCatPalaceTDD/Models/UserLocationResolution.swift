//
//  UserLocationResolution.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation

enum UserLocationResolution {
    case unknown
    case allowed
    case disallowed
    case resolving
    case resolved(location: CLPlacemark)
    case resolutionFailure(error: Error)
}
