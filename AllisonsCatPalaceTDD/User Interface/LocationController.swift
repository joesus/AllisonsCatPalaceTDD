//
//  LocationController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import AnimalData
import LocationResolving
import UIKit

class LocationController: UIViewController {

    private static let hourTimeInterval: TimeInterval =
        60 /* seconds per minute */ *
        60 /* minutes per hour */

    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var speciesSelectionControl: UISegmentedControl!

    var locationResolutionScene: LocationResolutionDisplaying!

    lazy var locationResolver: LocationResolving = {
        var resolver = Dependencies.locationResolverFactory()
        resolver.delegate = self
        return resolver
    }()

    var urlOpener: UrlOpening = UIApplication.shared

    var selectedSpecies: Species? {
        switch speciesSelectionControl.selectedSegmentIndex {
        case 0: return .cat
        case 1: return .dog

        default: return nil
        }
    }

    private var needsUpdateOnAppearance = true
    private var lastSuccessfulResolutionDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        observeApplicationAppearanceEvents()

        speciesSelectionControl.setTitleTextAttributes(
            [.font: UIFont.preferredFont(forTextStyle: .title2)],
            for: .normal
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        handleAppearance()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        handleDisappearance()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        precondition(segue.destination is LocationResolutionController,
                     "Segue destination should have correct controller")

        if let scene = segue.destination as? LocationResolutionController {
            locationResolutionScene = scene
            locationResolutionScene.delegate = self
        }
    }

    @objc private func handleAppearance() {
        guard needsUpdateOnAppearance else { return }

        needsUpdateOnAppearance = false

        switch locationResolver.userLocationResolvability {
        case .unknown:
            locationResolver.requestUserLocationAuthorization(for: .whenInUse)
            locationResolutionScene.configure(for: .resolving)

        case .disallowed:
            locationResolutionScene.configure(for: .actionable(action: .goToSettings))

        case .allowed:
            if let date = lastSuccessfulResolutionDate,
                Date() < date.addingTimeInterval(LocationController.hourTimeInterval) {

                return
            }
            else {
                locationResolver.resolveUserLocation()
                locationResolutionScene.configure(for: .resolving)
            }
        }
    }

    @objc private func handleDisappearance() {
        needsUpdateOnAppearance = true
    }

    private func observeApplicationAppearanceEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LocationController.handleDisappearance),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LocationController.handleAppearance),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

}

extension LocationController: LocationResolutionDisplayDelegate {

    func userRequestedResolutionAction(_ action: LocationResolutionDisplayState.Action) {
        switch action {
        case .retry:
            locationResolver.resolveUserLocation()

        case .goToSettings:
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            urlOpener.open(url, options: [:], completionHandler: nil)
        }
    }

}

extension LocationController: LocationResolutionDelegate {

    func didResolveLocation(_ location: LocationResolution) {
        switch location {
        case let .resolved(placemark, date):
            lastSuccessfulResolutionDate = date
            locationResolutionScene.configure(
                for: .resolved(placemark: placemark)
            )

        case .resolutionFailed:
            locationResolutionScene.configure(
                for: .actionable(action: .retry)
            )
        }
    }

}
