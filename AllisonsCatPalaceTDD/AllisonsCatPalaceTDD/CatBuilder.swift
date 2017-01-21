//
//  CatBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/16/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class CatBuilder {

    static func buildCatFromExternalCat(_ json: ExternalCat) -> Cat? {
        guard let name = json[ExternalCatKeys.name] as? String,
            let identifier = json[ExternalCatKeys.id] as? Int else {
                return nil
        }
        return Cat(name: name, identifier: identifier)
    }
}
