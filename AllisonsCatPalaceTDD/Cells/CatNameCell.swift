//
//  CatNameCell.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 4/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class CatNameCell: UITableViewCell {
    private static let middleColorEncodingKey = "middleColor"

    @IBOutlet weak var nameLabel: UILabel!
    @IBInspectable var middleColor: UIColor = .white

    // is on every view
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    override func encode(with coder: NSCoder) {
        super.encode(with: coder)

        coder.encode(middleColor, forKey: CatNameCell.middleColorEncodingKey)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        if let color = coder.decodeObject(forKey: CatNameCell.middleColorEncodingKey) as? UIColor {
            middleColor = color
        }

        commonInit()
    }

    private func commonInit() {
        if let gradient = layer as? CAGradientLayer {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            gradient.colors = [UIColor.red.cgColor, middleColor.cgColor, UIColor.blue.cgColor]
        }
    }
}
