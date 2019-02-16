//
//  AnimalBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/16/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias PetFinderResponse = JsonObject

protocol AnimalBuilder {
    associatedtype ExternalAnimal

    static func buildAnimals(from response: ExternalAnimal) -> [Animal]
    static func buildAnimal(from response: ExternalAnimal) -> Animal?
}

final class PetFinderAnimalBuilder: AnimalBuilder {

    private static func decodeExternalAnimalList(from response: PetFinderResponse) -> ExternalAnimalList? {
        let levelOne = response[ExternalAnimalKeys.resultContainer] as? JsonObject
        let levelTwo = levelOne?[ExternalAnimalKeys.petListContainer] as? JsonObject
        return levelTwo?[ExternalAnimalKeys.petContainer] as? ExternalAnimalList
    }

    private static func decodeExternalAnimal(from response: PetFinderResponse) -> ExternalAnimal? {
        let levelOne = response[ExternalAnimalKeys.resultContainer] as? JsonObject
        return levelOne?[ExternalAnimalKeys.petContainer] as? ExternalAnimal
    }

    private static func buildAnimalFromExternalAnimal(_ json: ExternalAnimal) -> Animal? {
        guard let nameContainer = json[ExternalAnimalKeys.name] as? JsonObject,
            let name = nameContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let identifierContainer = json[ExternalAnimalKeys.identifier] as? JsonObject,
            let identifierString = identifierContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let identifier = Int(identifierString) else {
                return nil
        }
        let animal = Animal(name: name, identifier: identifier)

        if let media = json[ExternalAnimalKeys.media] as? JsonObject,
            let photoContainer = media[ExternalAnimalKeys.photos] as? JsonObject,
            let photos = photoContainer[ExternalAnimalKeys.photo] as? JsonArray {

            animal.imageLocations = buildImageLocations(from: photos)
        }

        if let aboutContainer = json[ExternalAnimalKeys.about] as? JsonObject,
            let about = aboutContainer[ExternalAnimalKeys.elementContentKey] as? String {
            animal.about = about
        }

        if let ageContainer = json[ExternalAnimalKeys.age] as? JsonObject,
            let ageString = ageContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let age = AnimalAgeGroup(petFinderRawValue: ageString) {
            animal.age = age
        }

        if let contactContainer = json[ExternalAnimalKeys.contact] as? JsonObject,
            let cityContainer = contactContainer[ExternalAnimalKeys.city] as? JsonObject,
            let city = cityContainer[ExternalAnimalKeys.elementContentKey] as? String {
            animal.city = city
        }

        if let contactContainer = json[ExternalAnimalKeys.contact] as? JsonObject,
            let stateContainer = contactContainer[ExternalAnimalKeys.state] as? JsonObject,
            let state = stateContainer[ExternalAnimalKeys.elementContentKey] as? String {
            animal.stateCode = state
        }

        if let sizeContainer = json[ExternalAnimalKeys.size] as? JsonObject,
            let sizeString = sizeContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let size = AnimalSize(petFinderRawValue: sizeString) {
            animal.size = size
        }

        if let sexContainer = json[ExternalAnimalKeys.sex] as? JsonObject,
            let sexString = sexContainer[ExternalAnimalKeys.elementContentKey] as? String,
            let sex = AnimalSex(petFinderRawValue: sexString) {
            animal.sex = sex
        }

        if let adoptionStatusContainer = json[ExternalAnimalKeys.adoptionStatus] as? JsonObject,
            let adoptionStatusString = adoptionStatusContainer[ExternalAnimalKeys.elementContentKey] as? String {
            animal.adoptionStatus = AnimalAdoptionStatus(petFinderRawValue: adoptionStatusString)
        }

        return animal
    }

    static func buildAnimals(from response: PetFinderResponse) -> [Animal] {
        guard let list = decodeExternalAnimalList(from: response) else {
            return []
        }

        return list.compactMap { buildAnimalFromExternalAnimal($0) }
    }

    static func buildAnimal(from response: PetFinderResponse) -> Animal? {
        guard let externalAnimal = decodeExternalAnimal(from: response) else {
            return nil
        }
        let animal = buildAnimalFromExternalAnimal(externalAnimal)
        animal?.genotype = GenotypeBuilder.buildGenotypeFromExternalGenotype(externalAnimal)
        return animal
    }

    private static func buildImageLocations(from photoArray: PhotoArray) -> AnimalImageLocations {
        var small = [URL]()
        var medium = [URL]()
        var large = [URL]()

        photoArray.forEach { photoData in
            guard let urlString = photoData[ExternalAnimalKeys.elementContentKey] as? String,
                let url = URL(string: urlString),
                let sizeString = photoData[ExternalAnimalKeys.photoSize] as? String,
                let size = AnimalPhotoSize(petFinderRawValue: sizeString) else {
                    return
            }

            switch size {
            case .small:
                small.append(url)
            case .medium:
                medium.append(url)
            case .large:
                large.append(url)
            }
        }

        return AnimalImageLocations(small: small, medium: medium, large: large)
    }
}
