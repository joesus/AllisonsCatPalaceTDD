//
//  PetFinderSearchParameters.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/14/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

protocol AnimalSearchParameters {
    var species: AnimalSpecies? { get }
}

struct PetFinderSearchParameters: AnimalSearchParameters {
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
        guard let value = species?.description else {
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
            value = "XL"
        case .large:
            value = "L"
        case .medium:
            value = "M"
        case .small:
            value = "S"
        }

        return URLQueryItem(
            name: QueryItemKeys.size,
            value: value
        )
    }

    private var sexQueryItem: URLQueryItem? {
        guard let validSex = sex else { return nil }

        let value: String?
        switch validSex {
        case .female:
            value = "F"
        case .male:
            value = "M"
        case .unknown:
            return nil
        }

        return URLQueryItem(
            name: QueryItemKeys.sex,
            value: value
        )
    }

    private var ageQueryItem: URLQueryItem? {
        guard let validAge = age else { return nil }

        return URLQueryItem(
            name: QueryItemKeys.age,
            value: validAge.rawValue
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
