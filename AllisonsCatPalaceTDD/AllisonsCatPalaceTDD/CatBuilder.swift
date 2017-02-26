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
        if let urlString = json[ExternalCatKeys.pictureURL] as? String,
            let url = URL(string: urlString) {
            return Cat(name: name, identifier: identifier, url: url)
        }
        return Cat(name: name, identifier: identifier)
    }

    static func buildCats(from data: Data) -> [Cat]? {
        guard let list = externalCatList(from: data) else {
            return nil
        }

        return list.flatMap { buildCatFromExternalCat($0) }
    }
}
