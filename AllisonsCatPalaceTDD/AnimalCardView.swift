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

    func configure(with animal: Animal) {
        if let imageUrl = animal.imageLocations.medium.first {
            load(imageUrl)
        } else if let imageUrl = animal.imageLocations.small.first {
            load(imageUrl)
        } else if let imageUrl = animal.imageLocations.large.first {
            load(imageUrl)
        }

        nameLabel.text = animal.name
    }

    private func load(_ imageUrl: URL) {
        if let image = ImageProvider.imageForUrl(imageUrl) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        } else {
            ImageProvider.getImage(for: imageUrl) { potentialImage in
                guard let image = potentialImage else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
    }
}
