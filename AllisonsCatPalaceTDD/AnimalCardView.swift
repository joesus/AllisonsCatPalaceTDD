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

    private var animalImage: UIImage? {
        didSet {
            imageView.image = animalImage
        }
    }

    func configure(with animal: Animal) {
        if let imageUrl = animal.imageLocations.medium.first {

            if let image = ImageProvider.imageForUrl(imageUrl) {
                DispatchQueue.main.async { [weak self] in
                    self?.animalImage = image
                }
            } else {
                ImageProvider.getImage(for: imageUrl) { potentialImage in
                    DispatchQueue.main.async { [weak self] in
                        self?.animalImage = potentialImage ?? #imageLiteral(resourceName: "catOutline")
                    }
                }
            }
        }

        nameLabel.text = animal.name
    }
}
