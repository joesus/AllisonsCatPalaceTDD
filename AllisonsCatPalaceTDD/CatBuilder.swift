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
        guard let name = json[ExternalCatKeys.name] as? String,
            let identifier = json[ExternalCatKeys.id] as? Int else {
                return nil
        }
        let cat = Cat(name: name, identifier: identifier)

        if let urlString = json[ExternalCatKeys.pictureURL] as? String,
            let url = URL(string: urlString) {
            cat.imageUrl = url
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

        if let city = json[ExternalCatKeys.city] as? String {
            cat.city = city
        }

        if let state = json[ExternalCatKeys.state] as? String {
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
}
