//
//  LocationResolutionError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

public enum LocationResolutionError: Error {
    case noLocationsFound, unknownError, missingPostalCode, invalidPostalCode

    public var message: String {
        switch self {
        case .noLocationsFound, .unknownError:
            return "We were unable to find your location"

        case .missingPostalCode:
            return "We were unable to find a postal code for your location"

        case .invalidPostalCode:
            return "We were unable to use the postal code for your location"
        }
    }
}
