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

    func configure(location: DisplayableLocation) {
        label.text = location.displayableString
    }
}
