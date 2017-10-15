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
        name: PetFinderSearchParameters.QueryItemKeys.location,
        value: SampleSearchParameters.zipCode.rawValue
    )

    static let speciesQueryItem = URLQueryItem(
        name: PetFinderSearchParameters.QueryItemKeys.species,
        value: AnimalSpecies.cat.rawValue
    )

    static let breedQueryItem = URLQueryItem(
        name: PetFinderSearchParameters.QueryItemKeys.breed,
        value: "egyptian"
    )

    static let ageQueryItem = URLQueryItem(
        name: PetFinderSearchParameters.QueryItemKeys.age,
        value: "adult"
    )

    static let sizeQueryItem = URLQueryItem(
        name: PetFinderSearchParameters.QueryItemKeys.size,
        value: "M"
    )

    static let sexQueryItem = URLQueryItem(
        name: PetFinderSearchParameters.QueryItemKeys.sex,
        value: "F"
    )

    static let zipCodeOnly = PetFinderSearchParameters(zipCode: zipCode)

    static let fullSearchOptions = PetFinderSearchParameters(
        zipCode: zipCode,
        species: .cat,
        breed: "egyptian",
        size: .medium,
        age: .adult,
        sex: .female
    )
}
