//
//  AnimalCardView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import ImageProviding

class AnimalCardView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var imageProvider: ImageProviding.Type!

    func configure(with animal: Animal) {
        if let imageUrl = animal.imageLocations.medium.first ??
            animal.imageLocations.small.first ??
            animal.imageLocations.large.first {

            load(imageUrl)
        }

        nameLabel.text = animal.name
    }

    private func load(_ imageUrl: URL) {
        if let image = Dependencies.imageProvider.image(for: imageUrl) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
        else {
            imageProvider.getImage(for: imageUrl) { potentialImage in
                guard let image = potentialImage else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
    }
}
