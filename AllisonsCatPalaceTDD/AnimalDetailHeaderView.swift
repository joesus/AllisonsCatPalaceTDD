//
//  AnimalDetailHeaderView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/13/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

@IBDesignable
class AnimalDetailHeaderView: UIView {
    @IBOutlet weak var imageView: UIImageView!

    var animal: Animal? {
        didSet {
            guard let url = animal?.imageLocations.large.first else {
                return
            }
            ImageProvider.getImage(for: url) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.setNeedsLayout()
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle(for: AnimalDetailHeaderView.self)
        if let view = bundle.loadNibNamed("AnimalDetailHeaderView", owner: self)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        loadNib()
    }
}
