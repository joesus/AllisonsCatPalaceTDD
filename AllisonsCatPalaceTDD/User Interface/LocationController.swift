//
//  LocationController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class LocationController: UIViewController, RealmInjected {

    private(set) var userLocationResolution: UserLocationResolution = {
        guard CLLocationManager.locationServicesEnabled() else {
            return .disallowed
        }

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .unknown
        case .authorizedWhenInUse, .authorizedAlways:
            return .allowed
        case .denied, .restricted:
            return .disallowed
        }
    }()

    @IBOutlet weak var locationResolutionStack: UIStackView!
    @IBOutlet weak var resolvingLocationView: ResolvingLocationView!
    @IBOutlet weak var resolvedLocationView: ResolvedLocationView!

    @IBOutlet weak var actionableMessageView: UIView!
    @IBOutlet weak var actionableMessageLabel: UILabel!
    @IBOutlet weak var actionableMessageButton: UIButton!

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var speciesSelectionControl: UISegmentedControl! {
        didSet {
            speciesSelectionControl.setTitleTextAttributes(
                [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .title2)],
                for: .normal
            )
        }
    }

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    var geocoder = CLGeocoder()

    private var hasUserLocationPermissions: Bool {
        return CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }

    private var shouldPromptForLocationAuthorization: Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }

        return CLLocationManager.authorizationStatus() == .notDetermined
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationResolutionStack()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if realm?.objects(AnimalObject.self) == nil ||
           realm?.objects(AnimalObject.self).isEmpty == true {

            navigationItem.setLeftBarButton(nil, animated: true)
        } else {
            navigationItem.setLeftBarButton(favoritesButton, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        switch userLocationResolution {
        case .unknown:
            guard CLLocationManager.authorizationStatus() != .notDetermined else {
                locationManager.requestWhenInUseAuthorization()
                return
            }

            let newResolution: UserLocationResolution = hasUserLocationPermissions ?
                .resolving : .disallowed

            transition(to: newResolution)

        case .disallowed:
            if shouldPromptForLocationAuthorization {
                transition(to: .unknown)
            }
            else if hasUserLocationPermissions {
                transition(to: .resolving)
            }

        case .allowed:
            transition(to: hasUserLocationPermissions ? .resolving : .disallowed)

        case .resolving:
            locationManager.requestLocation()

        case .resolutionFailure:
            if hasUserLocationPermissions {
                transition(to: .resolving)
            }
            else {
                transition(to: .disallowed)
            }

        default:
            break
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }
    }

    func transition(to locationResolution: UserLocationResolution) {
        userLocationResolution = locationResolution
        configureLocationResolutionStack()
        searchButton.isEnabled = shouldEnableSearchButton
        advanceResolution()
    }

    func advanceResolution() {
        switch userLocationResolution {
        case .unknown:
            locationManager.requestWhenInUseAuthorization()

        case .resolving:
            locationManager.requestLocation()

        default:
            break
        }
    }

    func configureLocationResolutionStack() {
        locationResolutionStack.arrangedSubviews.forEach { subview in
            subview.isHidden = true
        }

        var viewToShow: UIView?
        switch userLocationResolution {
        case .disallowed:
            viewToShow = actionableMessageView
            configureActionableMessageView()

        case .resolving:
            viewToShow = resolvingLocationView

        case .resolved:
            viewToShow = resolvedLocationView
            configureResolvedLocationView()

        case .resolutionFailure:
            viewToShow = actionableMessageView
            configureActionableMessageView()

        default:
            break
        }

        viewToShow?.isHidden = false
    }

    private func configureActionableMessageView() {
        let message: String
        let title: String

        switch userLocationResolution {
        case .disallowed:
            message = "Looks like you're in a top secret location. In order to find the pets closest to you, AdoptR needs to know where you are."
            title = "Open Settings"

        case .resolutionFailure:
            message = "We seem to be having trouble locating you."
            title = "Find My Location"

        default:
            return
        }

        actionableMessageLabel.text = message
        actionableMessageButton.setTitle(title, for: .normal)
    }

    private func configureResolvedLocationView() {
        guard case .resolved(let location) = userLocationResolution else { return }

        resolvedLocationView.configure(
            city: location.locality,
            state: location.administrativeArea,
            zip: location.postalCode
        )
    }

    fileprivate var shouldEnableSearchButton: Bool {
        if case .resolved = userLocationResolution {
            return true
        }
        else {
            return false
        }
    }

    @IBAction func continueLocationResolution() {
        switch userLocationResolution {
        case .resolutionFailure:
            if hasUserLocationPermissions {
                transition(to: .resolving)
            }
            else {
                transition(to: .disallowed)
            }

        case .disallowed:
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }

            UIApplication.shared.open(url, options: [:])

        default:
            fatalError()
        }

    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        geocoder.reverseGeocodeLocation(location) {
            [weak self] potentialPlacemarks, potentialError in

            if let error = potentialError {
                self?.transition(to: .resolutionFailure(error: error))
            }
            else if let placemark = potentialPlacemarks?.first {
                self?.transition(to: .resolved(location: placemark))
            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        transition(to: .resolutionFailure(error: error))
    }
}
