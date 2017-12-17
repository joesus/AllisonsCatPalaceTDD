//
//  DisplayableString.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/17/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

extension String {

    var displayableString: String? {
        let string = trimmingCharacters(in: .whitespacesAndNewlines)

        return string.isEmpty ? nil : string
    }

}
