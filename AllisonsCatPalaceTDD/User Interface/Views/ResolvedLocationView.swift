//
//  ResolvedLocationView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class ResolvedLocationView: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    struct SimplifiedLocationName {
        let zipCode: ZipCode
        let city: String?
        let state: String?

        var displayableString: String {
            if let validCity = city,
                let validState = state {
                return "\(validCity), \(validState)"
            }
            else {
                var displayable = zipCode.rawValue
                if let potentialSingleName = [city, state]
                    .flatMap({ $0 })
                    .first {
                    displayable += " (\(potentialSingleName))"
                }

                return displayable
            }
        }
    }

    func configure(locationName: SimplifiedLocationName) {
        label.text = locationName.displayableString
    }
}
