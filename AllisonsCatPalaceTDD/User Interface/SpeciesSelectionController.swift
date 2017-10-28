//
//  SpeciesSelectionController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 9/6/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit

class SpeciesSelectionController: UIViewController {

    @IBOutlet private(set) weak var catsButton: UIButton!
    @IBOutlet private(set) weak var dogsButton: UIButton!
    @IBOutlet private(set) weak var anyButton: UIButton!

    @IBAction func speciesTapped(_ sender: UIButton) {
        switch sender {
        case catsButton:
            SettingsManager.shared.set(value: AnimalSpecies.cat.rawValue, forKey: .species)
        case dogsButton:
            SettingsManager.shared.set(value: AnimalSpecies.dog.rawValue, forKey: .species)
        default:
            SettingsManager.shared.set(value: nil, forKey: .species)
        }

        performSegue(withIdentifier: "ShowLocationController", sender: nil)
    }
}
