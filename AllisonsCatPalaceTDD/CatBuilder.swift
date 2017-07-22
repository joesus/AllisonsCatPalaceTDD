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

        if let about = json[ExternalCatKeys.about] as? String {
            cat.about = about
        }

        if let age = json[ExternalCatKeys.age] as? Int {
            cat.age = age
        }

        if let city = json[ExternalCatKeys.city] as? String {
            cat.city = city
        }

        if let state = json[ExternalCatKeys.state] as? String {
            cat.stateCode = state
        }

        if let cutenessLevel = json[ExternalCatKeys.cutenessLevel] as? Int {
            cat.cutenessLevel = cutenessLevel
        }

        if let greeting = json[ExternalCatKeys.greeting] as? String {
            cat.greeting = greeting
        }

        if let weight = json[ExternalCatKeys.weight] as? Int {
            cat.weight = weight
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
