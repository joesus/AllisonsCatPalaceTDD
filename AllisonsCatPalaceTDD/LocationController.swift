//
//  LocationController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class LocationController: UIViewController {
    @IBOutlet weak var zipCodeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        decorateZipCodeField()
        zipCodeField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func decorateZipCodeField() {
        zipCodeField.layer.cornerRadius = 4
        zipCodeField.layer.borderWidth = 1
        zipCodeField.layer.borderColor = UIColor.lightGray.cgColor
    }

    fileprivate var zipCodeText: String {
        return zipCodeField.text ?? ""
    }

    func textFieldDidChange(_ textField: UITextField) {
        if zipCodeText.characters.count >= 5 {
            textField.endEditing(true)
        }
    }
}

extension LocationController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let originalString = textField.text ?? ""
        let newString = (originalString as NSString).replacingCharacters(in: range, with: string)

        if newString.characters.count > 5 {
            textField.endEditing(true)
            return false
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

}
