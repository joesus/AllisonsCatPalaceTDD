//
//  DesignableViewProperties.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 2/24/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }

            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
