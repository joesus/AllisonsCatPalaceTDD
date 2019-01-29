//
//  FakeLocationResolutionController.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/30/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import UIKit
@testable import AllisonsCatPalaceTDD

class FakeLocationResolutionController: UIViewController, LocationResolutionDisplaying {
    weak var delegate: LocationResolutionDisplayDelegate?

    var state: LocationResolutionDisplayState?
    func configure(for state: LocationResolutionDisplayState) {
        self.state = state
    }
}
