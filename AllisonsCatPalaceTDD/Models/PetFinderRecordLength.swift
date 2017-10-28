//
//  PetFinderRecordLength.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum PetFinderRecordLength: CustomStringConvertible {
    case short, long

    var description: String {
        switch self {
        case .short:
            return "basic"
        case .long:
            return "full"
        }
    }

    var queryItem: URLQueryItem {
        return URLQueryItem(
            name: PetFinderUrlBuilder.BaseQueryItemKeys.recordLength,
            value: description
        )
    }
}
