//
//  CatBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/16/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

final class CatBuilder {

    private static func decodeExternalCatList(from data: Data) -> ExternalCatList? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json as? ExternalCatList
    }

    private static func decodeExternalCat(from data: Data) -> ExternalCat? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json as? ExternalCat
    }

    private static func buildCatFromExternalCat(_ json: ExternalCat) -> Cat? {
        guard let nameContainer = json[ExternalCatKeys.name] as? JsonObject,
            let name = nameContainer[ExternalCatKeys.elementContentKey] as? String,
            let identifierContainer = json[ExternalCatKeys.id] as? JsonObject,
            let identifierString = identifierContainer[ExternalCatKeys.elementContentKey] as? String,
            let identifier = Int(identifierString) else {
                return nil
        }
        let cat = Cat(name: name, identifier: identifier)

        if let media = json[ExternalCatKeys.media] as? JsonObject,
            let photoContainer = media[ExternalCatKeys.photos] as? JsonObject,
            let photos = photoContainer[ExternalCatKeys.photo] as? JsonArray {

            cat.imageLocations = buildImageLocations(from: photos)
        }

        if let aboutContainer = json[ExternalCatKeys.about] as? JsonObject,
            let about = aboutContainer[ExternalCatKeys.elementContentKey] as? String {
            cat.about = about
        }

        if let ageContainer = json[ExternalCatKeys.age] as? JsonObject,
            let ageString = ageContainer[ExternalCatKeys.elementContentKey] as? String,
            let age = AnimalAgeGroup(petFinderRawValue: ageString) {
            cat.age = age
        }

        if let contactContainer = json[ExternalCatKeys.contact] as? JsonObject,
            let cityContainer = contactContainer[ExternalCatKeys.city] as? JsonObject,
            let city = cityContainer[ExternalCatKeys.elementContentKey] as? String {
            cat.city = city
        }

        if let contactContainer = json[ExternalCatKeys.contact] as? JsonObject,
            let stateContainer = contactContainer[ExternalCatKeys.state] as? JsonObject,
            let state = stateContainer[ExternalCatKeys.elementContentKey] as? String {
            cat.stateCode = state
        }

        if let sizeContainer = json[ExternalCatKeys.size] as? JsonObject,
            let sizeString = sizeContainer[ExternalCatKeys.elementContentKey] as? String,
            let size = AnimalSize(petFinderRawValue: sizeString) {
            cat.size = size
        }

        if let sexContainer = json[ExternalCatKeys.sex] as? JsonObject,
            let sexString = sexContainer[ExternalCatKeys.elementContentKey] as? String,
            let sex = AnimalSex(petFinderRawValue: sexString) {
            cat.sex = sex
        }

        return cat
    }

    static func buildCats(from data: Data) -> [Cat] {
        guard let list = decodeExternalCatList(from: data) else {
            return []
        }

        return list.flatMap { buildCatFromExternalCat($0) }
    }

    static func buildCat(from data: Data) -> Cat? {
        guard let cat = decodeExternalCat(from: data) else {
            return nil
        }
        return buildCatFromExternalCat(cat)
    }

    private static func buildImageLocations(from photoArray: PhotoArray) -> AnimalImageLocations {
        var small = [URL]()
        var medium = [URL]()
        var large = [URL]()

        photoArray.forEach { photoData in
            guard let urlString = photoData[ExternalCatKeys.elementContentKey] as? String,
                let url = URL(string: urlString),
                let sizeString = photoData[ExternalCatKeys.photoSize] as? String,
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
