//
//  ActionableMessageView.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

protocol ButtonTapDelegate: class {
    func buttonTapped()
}

class ActionableMessageView: UIView {

    @IBOutlet private(set) weak var messageLabel: UILabel!
    @IBOutlet private(set) weak var button: UIButton!
    weak var delegate: ButtonTapDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func set(message: String, actionTitle: String) {
        messageLabel.text = message
        button.setTitle(actionTitle, for: .normal)
    }

    private func loadNib() {
        let bundle = Bundle(for: ActionableMessageView.self)
        if let view = bundle.loadNibNamed("ActionableMessageView", owner: self)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        loadNib()
    }

    @IBAction func buttonTapped() {
        delegate?.buttonTapped()
    }
}
