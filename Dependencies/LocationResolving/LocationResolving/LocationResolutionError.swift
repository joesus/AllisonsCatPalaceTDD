//
//  LocationResolutionError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

public enum LocationResolutionError: Error {
    case noLocationsFound, requestInProgress, unknown

    public var userFacingMessage: String {
        switch self {
        case .noLocationsFound, .unknown:
            return "We were unable to find your location"
        case .requestInProgress:
            return "Finding your location"
        }
    }
}
