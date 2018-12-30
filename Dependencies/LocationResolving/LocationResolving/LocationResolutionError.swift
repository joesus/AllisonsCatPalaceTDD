//
//  LocationResolutionError.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

public enum LocationResolutionError: Error, CaseIterable {
    case disallowed, locationNotFound, unknown
}
