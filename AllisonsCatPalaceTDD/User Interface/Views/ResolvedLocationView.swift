//
//  ResolvedLocationView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

@IBDesignable
class ResolvedLocationView: UIView {

    @IBOutlet weak var locationIndicator: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle(for: ResolvedLocationView.self)
        if let view = bundle.loadNibNamed("ResolvedLocationView", owner: self)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        loadNib()
    }
}

