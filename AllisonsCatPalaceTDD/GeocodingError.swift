//
//  GeocodingError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum GeocodingError: Error {
    case noLocationsFound, unknownError

    var message: String {
        switch self {
        case .noLocationsFound:
            return "We can't find that zip code, did you enter it right?"
        case .unknownError:
            return "We misplaced our atlas, please try again."
        }
    }
}
