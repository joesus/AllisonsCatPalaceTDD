//
//  AnimalData.swift
//  AnimalData
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import Foundation

public class AnimalData {
    public let name: String
    public let species: Species

    public init(name: String, species: Species) {
        self.name = name
        self.species = species
    }
}
