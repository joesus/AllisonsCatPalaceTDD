//
//  AnimalCardView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class AnimalCardView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(with animal: Animal, image: UIImage) {
        self.imageView.image = image
        self.nameLabel.text = animal.name
    }
}
