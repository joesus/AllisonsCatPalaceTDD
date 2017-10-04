//
//  LocationController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: UIViewController {
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        decorateZipCodeField()
        populateZipCodeField()
        zipCodeField.addTarget(self, action: #selector(LocationController.textFieldDidChange(_:)), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        populateZipCodeField()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        zipCodeField.becomeFirstResponder()
    }

    fileprivate func decorateZipCodeField() {
        zipCodeField.layer.cornerRadius = 4
        zipCodeField.layer.borderWidth = 1
        zipCodeField.layer.borderColor = UIColor.lightGray.cgColor
    }

    fileprivate func populateZipCodeField() {
        let storedZipCode = SettingsManager.shared.value(forKey: .zipCode) as? String
        zipCodeField.text = storedZipCode
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor

        activityIndicator.stopAnimating()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let originalString = textField.text ?? ""
        let newString = (originalString as NSString).replacingCharacters(in: range, with: string)
        let newStringOnlyContainsDecimals = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newString))

        guard newStringOnlyContainsDecimals else {
            return false
        }

        if newString.characters.count == 5 {
            textField.resignFirstResponder()
        }

        if newString.characters.count > 5 {

            return false
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activityIndicator.startAnimating()
        textField.isUserInteractionEnabled = false

        geocodeAddress(zipCodeText)
    }

    private func geocodeAddress(_ text: String) {
        geocoder.geocodeAddressString(zipCodeText) { [weak self] (placemarks, error) in
            // geocode
            self?.activityIndicator.stopAnimating()
            self?.zipCodeField.isUserInteractionEnabled = true

            guard error == nil,
                let locations = placemarks,
                locations.isEmpty == false,
                let zipCode = locations.first?.postalCode else {

                    self?.zipCodeField.layer.borderColor = UIColor.red.cgColor
                    return
            }

            SettingsManager.shared.set(value: zipCode, forKey: .zipCode)

            self?.performSegue(withIdentifier: "ShowCatListController", sender: nil)
        }
    }
}
