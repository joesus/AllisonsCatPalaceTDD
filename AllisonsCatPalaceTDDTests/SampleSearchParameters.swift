//
//  SampleSearchParameters.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

enum SampleSearchParameters {
    static let zipCode = ZipCode(rawValue: "80220")!
    static let zipCodeQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.location,
        value: SampleSearchParameters.zipCode.rawValue
    )

    static let speciesQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.species,
        value: AnimalSpecies.cat.rawValue
    )

    static let breedQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.breed,
        value: "egyptian"
    )

    static let ageQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.age,
        value: "adult" // TODO - make this a string backed enum
    )

    static let sizeQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.size,
        value: "medium" // TODO - make this a string backed enum
    )

    static let sexQueryItem = URLQueryItem(
        name: AnimalSearchParameters.QueryItemKeys.sex,
        value: "female" // TODO - make this a string backed enum
    )

    static let zipCodeOnly = AnimalSearchParameters(zipCode: zipCode)

    static let fullSearchOptions = AnimalSearchParameters(
        zipCode: zipCode,
        species: .cat,
        breed: "egyptian",
        size: .medium,
        age: .adult,
        sex: .female
    )
}
