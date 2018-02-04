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

    enum SimplifiedLocationName {
        case unknown
        case withZipCode(code: String, cityOrState: String?)
        case withoutZipCode(cityOrState: String, state: String?)

        init(city: String?, state: String?, zip: String?) {
            if let validCity = city {
                if let validState = state {
                    self = .withoutZipCode(cityOrState: validCity, state: validState)
                }
                else if let validZip = zip {
                    self = .withZipCode(code: validZip, cityOrState: validCity)
                }
                else {
                    self = .withoutZipCode(cityOrState: validCity, state: nil)
                }
            }
            else if let validState = state {
                if let validZip = zip {
                    self = .withZipCode(code: validZip, cityOrState: validState)
                }
                else {
                    self = .withoutZipCode(cityOrState: validState, state: nil)
                }
            }
            else if let validZip = zip {
                self = .withZipCode(code: validZip, cityOrState: nil)
            }
            else {
                self = .unknown
            }
        }

        var displayableString: String {
            switch self {
            case .unknown:
                return "Location Unknown"

            case .withZipCode(let code, let cityOrState):
                var secondaryString: String?
                if let secondaryLocation = cityOrState {
                    secondaryString = "(\(secondaryLocation))"
                }

                let strings = [code, secondaryString]
                return strings.flatMap { $0 }
                    .joined(separator: " ")

            case .withoutZipCode(let cityOrState, let state):
                return [cityOrState, state].flatMap { $0 }
                    .joined(separator: ", ")
            }
        }
    }

    func configure(city: String? = nil, state: String? = nil, zip: String? = nil) {
        let locationName = SimplifiedLocationName(
            city: city,
            state: state,
            zip: zip
        )

        label.text = locationName.displayableString
    }
}
