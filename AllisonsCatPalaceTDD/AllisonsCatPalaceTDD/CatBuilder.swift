//
//  CatBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/16/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class CatBuilder {

    static func buildExternalCatFromJSON(_ json: [String: Any]) -> ExternalCat {
        return ExternalCat(name: json[ExternalCat.ServerKeys.name] as? String,
                           identifier: json[ExternalCat.ServerKeys.id] as? Int
        )
    }

    static func buildCatFromExternalCat(_ cat: ExternalCat) -> Cat? {
        guard let name = cat.name, let identifier = cat.identifier else { return nil }

        return Cat(name: name, identifier: identifier)
    }
}
