//
//  CatBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/16/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

final class CatBuilder {

    static func externalCatList(from data: Data) -> ExternalCatList? {
        guard let catList = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        return catList as? ExternalCatList
    }

    static func buildCatFromExternalCat(_ json: ExternalCat) -> Cat? {
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

        if let genderString = json[ExternalCatKeys.gender] as? String,
            let gender = Gender(rawValue: genderString) {
            cat.gender = gender
        }

        return cat
    }

    static func buildCats(from data: Data) -> [Cat]? {
        guard let list = externalCatList(from: data) else {
            return nil
        }

        return list.flatMap { buildCatFromExternalCat($0) }
    }
}
