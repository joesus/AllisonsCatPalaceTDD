//
//  ResolvingLocationView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class ResolvingLocationView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!

    override var isHidden: Bool {
        didSet {
            isHidden ? activityIndicator?.stopAnimating() : activityIndicator?.startAnimating()
        }
    }

}
