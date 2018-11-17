//
//  SearchParameters.swift
//  AnimalProviding
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import CoreLocation

public protocol SearchParameters {
    var location: CLPlacemark { get }
    var species: Species? { get }
}
