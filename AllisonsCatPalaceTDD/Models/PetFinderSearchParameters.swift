//
//  PetFinderSearchParameters.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

struct PetFinderSearchParameters {
    let zipCode: ZipCode
    let species: AnimalSpecies?
    let breed: AnimalBreed?
    let size: AnimalSize?
    let age: AnimalAgeGroup?
    let sex: AnimalSex?

    init(
        zipCode: ZipCode,
        species: AnimalSpecies? = nil,
        breed: AnimalBreed? = nil,
        size: AnimalSize? = nil,
        age: AnimalAgeGroup? = nil,
        sex: AnimalSex? = nil
        ) {

        self.zipCode = zipCode
        self.species = species
        self.breed = breed
        self.size = size
        self.age = age
        self.sex = sex
    }

    private var zipCodeQueryItem: URLQueryItem {
        return URLQueryItem(
            name: QueryItemKeys.location,
            value: zipCode.rawValue
        )
    }

    private var speciesQueryItem: URLQueryItem? {
        guard let value = species?.rawValue else {
            return nil
        }

        return URLQueryItem(
            name: QueryItemKeys.species,
            value: value
        )
    }

    private var breedQueryItem: URLQueryItem? {
        guard let value = breed else {
            return nil
        }

        return URLQueryItem(
            name: QueryItemKeys.breed,
            value: value
        )
    }

    private var sizeQueryItem: URLQueryItem? {
        guard let validSize = size else { return nil }

        let value: String?
        switch validSize {
        case .extraLarge:
            value = "extraLarge"
        case .large:
            value = "large"
        case .medium:
            value = "medium"
        case .small:
            value = "small"
        }

        return URLQueryItem(
            name: QueryItemKeys.size,
            value: value
        )
    }

    private var sexQueryItem: URLQueryItem? { // TODO - make this backed by string but make sure this check is still here for unknown
        guard let validSex = sex else { return nil }

        let value: String?
        switch validSex {
        case .female:
            value = "female"
        case .male:
            value = "male"
        case .unknown:
            return nil
        }

        return URLQueryItem(
            name: QueryItemKeys.sex,
            value: value
        )
    }

    private var ageQueryItem: URLQueryItem? { // TODO - make this backed by string,
        guard let validAge = age else { return nil }

        let value: String?
        switch validAge {
        case .baby:
            value = "baby"
        case .young:
            value = "young"
        case .adult:
            value = "adult"
        case .senior:
            value = "senior"
        }

        return URLQueryItem(
            name: QueryItemKeys.age,
            value: value
        )
    }

    var queryItems: Set<URLQueryItem> {
        let queryItems = [
            zipCodeQueryItem,
            speciesQueryItem,
            breedQueryItem,
            sizeQueryItem,
            ageQueryItem,
            sexQueryItem
        ]

        return Set(queryItems.flatMap { $0 })
    }
}

extension PetFinderSearchParameters {
    enum QueryItemKeys {
        static let location = "location"
        static let species = "animal"
        static let breed = "breed"
        static let size = "size"
        static let sex = "sex"
        static let age = "age"
    }
}
