//
//  LocationResolutionController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationResolutionDelegate: class {
    func userRequestedResolutionAction(_ action: LocationResolutionController.Action)
}

class LocationResolutionController: UIViewController {

    weak var delegate: LocationResolutionDelegate?
    private var actionToPerform: Action?

    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var resolvingView: ResolvingLocationView!
    @IBOutlet weak var resolvedView: ResolvedLocationView!

    @IBOutlet weak var actionableView: UIView!
    @IBOutlet weak var actionableLabel: UILabel!
    @IBOutlet weak var actionableButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideArrangedSubviews()
    }

    private func hideArrangedSubviews() {
        mainStack.arrangedSubviews.forEach { subview in
            subview.isHidden = true
        }
    }

    @IBAction func performAction() {
        guard let action = actionToPerform else { return }

        delegate?.userRequestedResolutionAction(action)
        actionToPerform = nil
    }

    func configure(for state: State) {
        hideArrangedSubviews()
        actionToPerform = nil

        switch state {
        case .resolving:
            resolvingView.isHidden = false

        case .resolved(let placemark):
            showResolved(placemark: placemark)

        case .actionable(action: let action):
            showActionable(action: action)
        }
    }

    private func showResolved(placemark: CLPlacemark) {
        resolvedView.isHidden = false
        resolvedView.configure(
            location: DisplayableLocation(placemark: placemark)
        )
    }

    private func showActionable(action: Action) {
        actionToPerform = action
        actionableView.isHidden = false

        let message: String
        let title: String

        switch action {
        case .goToSettings:
            message = """
            Looks like you're in a top secret location.
            In order to find the pets closest to you, AdoptR needs to know where you are.
            """
            title = "Open Settings"

        case .retry:
            message = "We seem to be having trouble locating you."
            title = "Find My Location"
        }

        actionableLabel.text = message
        actionableButton.setTitle(title, for: .normal)
    }

}

extension LocationResolutionController {
    enum Action {
        case goToSettings, retry
    }

    enum State {
        case resolving
        case resolved(placemark: CLPlacemark)
        case actionable(action: Action)
    }
}
