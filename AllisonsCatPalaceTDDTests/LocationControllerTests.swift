//
//  LocationControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import TestSwagger
import TestableUIKit
import TestableCoreLocation
import CoreLocation
import RealmSwift
import XCTest

class LocationControllerTests: XCTestCase {
    var controller: LocationController!
    var favoritesButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var geocoder: CLGeocoder!
    var geocoderSpy: Spy?
    var performSegueSpy: Spy?
    var openURLSpy: Spy?
    var navController: UINavigationController!
    var placemark: MutablePlacemark = {
        let mark = MutablePlacemark()
        mark.postalCode = "80220"
        return mark
    }()
    var realm: Realm!
    var locationManager: CLLocationManager!
    var requestAuthorizationSpy: Spy?
    var requestLocationSpy: Spy?

    override func setUp() {
        super.setUp()

        realm = realmForTest(withName: name!)
        resetRealm(realm)
        InjectionMap.realm = realm

        CLLocationManager.beginStubbingLocationServicesEnabled(with: true)
        CLLocationManager.beginStubbingAuthorizationStatus(with: .authorizedWhenInUse)

        loadController()
    }

    private func loadComponents() {
        controller.loadViewIfNeeded()

        favoritesButton = controller.favoritesButton
        searchButton = controller.searchButton
        geocoder = controller.geocoder

        geocoderSpy = CLGeocoder.ReverseGeocodeLocationSpyController.createSpy(on: geocoder)
        geocoderSpy?.beginSpying()

        navController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController() as! UINavigationController

        performSegueSpy = UIViewController.PerformSegueSpyController.createSpy(on: controller)
        performSegueSpy?.beginSpying()

        openURLSpy = UIApplication.OpenUrlSpyController.createSpy(on: UIApplication.shared)
        openURLSpy?.beginSpying()

        locationManager = controller.locationManager

        requestAuthorizationSpy = CLLocationManager.RequestWhenInUseAuthorizationSpyController
            .createSpy(on: locationManager)
        requestAuthorizationSpy?.beginSpying()

        requestLocationSpy = CLLocationManager.RequestLocationSpyController
            .createSpy(on: locationManager)
        requestLocationSpy?.beginSpying()
    }

    private func loadController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LocationController.self))
        controller = storyboard.instantiateViewController(withIdentifier: "LocationController") as? LocationController
    }

    override func tearDown() {
        geocoderSpy?.endSpying()
        performSegueSpy?.endSpying()
        openURLSpy?.endSpying()
        requestLocationSpy?.endSpying()
        requestAuthorizationSpy?.endSpying()

        CLLocationManager.endStubbingAuthorizationStatus()
        CLLocationManager.endStubbingLocationServicesEnabled()

        resetRealm(realm)

        super.tearDown()
    }

    // MARK: View Lifecycle

    func testViewDidLoad() {
        UIViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            loadComponents()
            XCTAssert(controller.superclassViewDidLoadCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        }
    }

    func testViewDidAppear() {
        UIViewController.ViewDidAppearSpyController.createSpy(on: controller)!.spy {
            replaceRootViewController(with: controller)
            controller.viewDidAppear(false)
            XCTAssert(controller.superclassViewDidAppearCalled,
                      "Controller should invoke its superclass implementation of `viewDidAppear(animated:)`")
        }
    }

    func testViewWillDisappear() {
        UIViewController.ViewWillDisappearSpyController.createSpy(on: controller)!.spy {
            replaceRootViewController(with: controller)
            controller.viewWillDisappear(false)
            XCTAssert(controller.superclassViewWillDisappearCalled,
                      "Controller should invoke its superclass implementation of `viewWillDisappear(animated:)`")
        }
    }

    func testViewDidDisappear() {
        UIViewController.ViewDidDisappearSpyController.createSpy(on: controller)!.spy {
            replaceRootViewController(with: controller)
            controller.viewDidDisappear(false)
            XCTAssert(controller.superclassViewDidDisappearCalled,
                      "Controller should invoke its superclass implementation of `viewDidDisappear(animated:)`")
        }
    }

    func testUpdatingOnReappearance() {
        loadController()
        loadComponents()

        CLLocationManager.stubbedAuthorizationStatus = .denied
        controller.viewDidAppear(false)

        // Disappearing will set a flag that causes appearing to update user location resolution
        controller.viewDidDisappear(false)
        CLLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse
        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "Controller should update user location resolution on reappearance")

        controller.transition(to: .disallowed)
        // entering the foreground does nothing if nothing caused the flag to be set
        NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: nil)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should not transition user location resolution on appearance if it was not previously backgrounded, disappeared, or was not part of the initial appearance")
    }

    func testUpdatingOnEnteringTheForeground() {
        loadController()
        loadComponents()

        CLLocationManager.stubbedAuthorizationStatus = .denied
        NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: nil)

        // Entering the background will set a flag that causes appearing to update user location resolution
        NotificationCenter.default.post(name: .UIApplicationDidEnterBackground, object: nil)
        CLLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse
        NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: nil)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "Controller should update user location resolution on reappearance")

        controller.transition(to: .disallowed)

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should not transition user location resolution on appearance if it was not previously backgrounded, disappeared, or was not part of the initial appearance")
    }

    // MARK: Initial User Location Resolution State

    func testUserLocationResolutionForDisabledLocationServices() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should have a user location resolution with an initial state of disallowed if location services are disabled")
    }

    func testUserLocationResolutionForFirstLaunch() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "Controller should have a user location resolution with an initial state of unknown when location services are enabled but authorization status is unknown")
    }

    func testUserLocationResolutionForUnauthorizedPermissions() {
        CLLocationManager.stubbedAuthorizationStatus = .denied
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should have a user location resolution with an initial state of disallowed if location services authorization has been denied")
    }

    func testUserLocationResolutionForEnabledAndAuthorizedLocationServices() {
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .allowed,
                       "Controller should have a user location resolution with an initial state of allowed if location services are enabled and authorized")
    }

    // MARK: - Initial User Location Transitions

    func testUserNotPromptedIfLocationServicesUnavailable() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location services are not available")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request when in use authorization if location services are not enabled")
    }

    func testLocationServicesPromptsWhenNotDetermined() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "User location resolution should be unknown when location permission is not determined")
        XCTAssertTrue(locationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request when in use authorization if status is not determined")
    }

    func testLocationServicesDoesNotPromptWhenPreviouslyDenied() {
        CLLocationManager.stubbedAuthorizationStatus = .denied
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location permission is denied")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if previously denied")
    }

    func testLocationServicesDoesNotPromptWhenRestricted() {
        CLLocationManager.stubbedAuthorizationStatus = .restricted
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location permission is restricted")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if user is restricted")
    }

    func testUserLocationResolutionRemainsDisallowedWhenLocationServicesDisabled() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadComponents()
        controller.transition(to: .disallowed)

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should not change user location resolution state")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request when in use authorization if location services disabled")
    }

    func testUserLocationResolutionRemainsDisallowedWhenLocationServicesRestricted() {
        loadComponents()
        controller.transition(to: .disallowed)

        CLLocationManager.stubbedAuthorizationStatus = .restricted

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should remain disallowed when location permission is restricted")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if previously restricted")
    }

    func testUserLocationResolutionRemainsDisallowedWhenLocationServicesUnauthorized() {
        loadComponents()
        controller.transition(to: .disallowed)

        CLLocationManager.stubbedAuthorizationStatus = .denied

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should remain disallowed when location permission is denied")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if previously denied")
    }

    func testUserLocationResolutionTransitionsFromDisallowedToResolvingWhenLocationServicesAuthorized() {
        loadComponents()
        controller.transition(to: .disallowed)

        CLLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should transition to resolving when location permission is granted")
    }

    func testUserLocationResolutionTransitionsFromAllowedToDisallowedWhenLocationServicesDisabled() {
        loadComponents()
        controller.transition(to: .allowed)

        CLLocationManager.stubbedLocationServicesEnabled = false

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed when location services disabled")
    }

    func testUserLocationResolutionTransitionsFromAllowedToDisallowedWhenLocationServicesDenied() {
        loadComponents()
        controller.transition(to: .allowed)

        CLLocationManager.stubbedAuthorizationStatus = .denied

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed when location permission is denied")
    }

    func testUserLocationResolutionTransitionsFromAllowedToDisallowedWhenLocationServicesRestricted() {
        loadComponents()
        controller.transition(to: .allowed)

        CLLocationManager.stubbedAuthorizationStatus = .restricted

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed when location permission is restricted")
    }

    func testUserLocationResolutionTransitionsFromAllowedToResolvingWhenLocationServicesAuthorized() {
        loadComponents()
        controller.transition(to: .allowed)

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should transition to resolving when location permission is granted")
    }

    // MARK: - Subsequent Appearance Transitions

    func testNewlyEnabledLocationServicesPromptsForAuthorizationWhenNotDetermined() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()
        loadComponents()

        CLLocationManager.stubbedLocationServicesEnabled = true

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "User location resolution should transition to unknown when location services are enabled")
        XCTAssertTrue(locationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request authorization if previously restricted")
    }

    func testUserLocationResolutionRemainsResolved() {
        loadComponents()
        let resolution = UserLocationResolution.resolved(location: SamplePlacemarks.denver)

        controller.transition(to: resolution)

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, resolution,
                       "User location resolution should not change once it has resolved")
    }

    func testTransitionsFromFailureToDisallowedForLocationServicesUnavailable() {
        loadComponents()

        let error = SampleError()
        controller.transition(to: .resolutionFailure(error: error))

        CLLocationManager.stubbedLocationServicesEnabled = false

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed if services unavailable regardless of previous failures")
    }

    func testTransitionsFromFailureToDisallowedForLocationPermissionsDenied() {
        loadComponents()

        controller.transition(to: .resolutionFailure(error: SampleError()))

        CLLocationManager.stubbedAuthorizationStatus = .denied

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed if location permissions denied regardless of previous failures")
    }

    func testTransitionsFromFailureToResolvingWhenLocationAvailable() {
        loadComponents()

        controller.transition(to: .resolutionFailure(error: SampleError()))

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should transition to resolving if location is available")
    }

    // MARK: - User Initiated Transitions

    func testDenyingLocationPermissionsPrompt() {
        loadComponents()
        CLLocationManager.stubbedAuthorizationStatus = .denied

        controller.locationManager(locationManager, didChangeAuthorization: .denied)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should transition to disallowed when location permissions are denied")
    }

    func testAcceptingLocationPermissionsPrompt() {
        loadComponents()
        CLLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse

        controller.locationManager(locationManager, didChangeAuthorization: .authorizedWhenInUse)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should transition to resolving when location permissions are allowed")
    }

    func testRetryingLocationResolutionAfterFailure() {
        loadComponents()

        controller.transition(to: .resolutionFailure(error: SampleError()))

        controller.continueLocationResolution() // same as tapping the actionable message view's button

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden after retrying location")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden after retrying location")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden after retrying location")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Should request location")
    }

    func testRetryingLocationResolutionWithResolvedLocation() {
        loadComponents()

        controller.transition(to: .resolved(location: SamplePlacemarks.denver))

        controller.continueLocationResolution()

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden after retrying location")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden after retrying location")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden after retrying location")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Should request location")
    }

    func testRetryingLocationResolutionWithResolvedLocationWhenLocationUnavailable() {
        loadComponents()

        controller.transition(to: .resolved(location: SamplePlacemarks.denver))

        CLLocationManager.stubbedLocationServicesEnabled = false

        controller.continueLocationResolution()

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                       "Resolving location view should be hidden after retrying location when location unavailable")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden after retrying location when location unavailable")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                      "Actionable message view should not be hidden after retrying location when location unavailable")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertFalse(locationManager.requestLocationCalled,
                      "Should not request location")
    }

    // MARK: - Default View Configurations

    func testResolvingLocationView() {
        loadComponents()

        guard let view = controller.resolvingLocationView,
            let label = view.label
            else {
                return XCTFail("Controller should have a view with an activity indicator and label for indicating that location is being resolved")
        }

        XCTAssertTrue(view.isHidden,
                      "Resolving location view should be hidden by default")
        XCTAssertEqual(label.text, "Finding Location",
                       "Resolving location view's label should have the expected text")
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 24),
                       "Resolving location view's label should have 24 point font")
        XCTAssertEqual(label.numberOfLines, 1,
                       "Resolving location view's label should have number of lines set to one")
        XCTAssertEqual(label.lineBreakMode, .byTruncatingTail,
                       "Resolving location view's label should have line break mode set to truncate tail")
        XCTAssertFalse(label.isHidden,
                       "Resolving location view's label should not be hidden")
    }

    func testResolvedLocationView() {
        loadComponents()

        guard let view = controller.resolvedLocationView,
            let icon = view.icon,
            let label = view.label,
            let button = view.button
            else {
                return XCTFail("Controller should have a view with an icon and label for indicating that location has been resolved")
        }

        XCTAssertTrue(view.isHidden,
                      "Resolved location view should be hidden by default")
        XCTAssertEqual(icon.image, #imageLiteral(resourceName: "location-pin"),
                       "Resolved location view should have an indicator image of a pin")

        XCTAssertEqual(label.font, .systemFont(ofSize: 24),
                       "Resolved location view's label should have 24 point font")
        XCTAssertEqual(label.numberOfLines, 1,
                       "Resolved location view's label should have number of lines set to one")
        XCTAssertEqual(label.lineBreakMode, .byTruncatingTail,
                       "Resolved location view's label should have line break mode set to truncate tail")
        XCTAssertFalse(label.isHidden,
                       "Resolved location view's label should not be hidden")
        XCTAssertEqual(button.title(for: .normal), "Update",
                       "Resolved location view's button should have the correct text")

        guard let action = button.actions(
            forTarget: controller,
            forControlEvent: .touchUpInside
            )?.onlyElement
            else {
                return XCTFail("The button should have an associated action")
        }

        XCTAssertEqual(action, #selector(LocationController.continueLocationResolution).description,
                       "The button should notify the view of the user's intent to find location")
    }

    func testActionableMessageView() {
        loadComponents()

        guard let view = controller.actionableMessageView,
            let label = controller.actionableMessageLabel,
            label.superview === view,
            let button = controller.actionableMessageButton,
            button.superview === view
            else {
                return XCTFail("Controller should have an actionable message view with a label and a button")
        }

        XCTAssertTrue(view.isHidden,
                      "Actionable message view should be hidden by default")
        XCTAssertEqual(label.font, UIFont.preferredFont(forTextStyle: .body),
                       "The message should have a body text style so that it can display larger sizes when needed")
        XCTAssertEqual(label.numberOfLines, 0,
                       "The message should have number of lines set to zero so that it display long text on multiple lines.")
        XCTAssertEqual(label.lineBreakMode, .byWordWrapping,
                       "The message should have line break mode set to word wrap so that it can display long text on multiple lines.")
        XCTAssertFalse(button.isHidden,
                       "The message should not be hidden")

        guard let action = button.actions(
            forTarget: controller,
            forControlEvent: .touchUpInside
            )?.onlyElement
            else {
                return XCTFail("The button should have an associated action")
        }

        XCTAssertEqual(action, #selector(LocationController.continueLocationResolution).description,
                       "The button should notify the view of the user's intent to find location")
    }

    func testSceneHasUserResolutionIndicationElementsInAStack() {
        loadComponents()

        guard let stackView = controller.locationResolutionStack else {
            return XCTFail("Controller should have a stack to hold the location resolution indicators")
        }

        let expectedStackContents: [UIView] = [
            controller.resolvingLocationView!,
            controller.resolvedLocationView!,
            controller.actionableMessageView!
        ]

        XCTAssertEqual(stackView.arrangedSubviews, expectedStackContents,
                       "Controller's location resolution indicators should be enclosed in a stack in the proper order")
    }

    func testSpeciesSelectionControl() {
        loadComponents()

        guard let control = controller.speciesSelectionControl else {
            return XCTFail("Controller should have a species selection control")
        }

        XCTAssertEqual(control.numberOfSegments, 3,
                       "Species selection control should have three options")
        XCTAssertEqual(control.selectedSegmentIndex, SpeciesSelectionIndex.cat.rawValue,
                       "Cat segment should be selected by default")

        let indices = [SpeciesSelectionIndex.cat, .dog, .any]
        indices.forEach { index in
            guard let title = control.titleForSegment(at: index.rawValue) else {
                return XCTFail("Each segment should have a title")
            }

            let expectedTitle: String
            switch index {
            case .cat: expectedTitle = "Cat"
            case .dog: expectedTitle = "Dog"
            case .any: expectedTitle = "Any"
            }

            XCTAssertEqual(title, expectedTitle,
                           "Title for segment at \(index.rawValue) should be \(index)")
        }

        guard let attributes = control.titleTextAttributes(for: .normal),
            let font = attributes[NSFontAttributeName] as? UIFont
            else {
                return XCTFail("Species segmented control should have a known font")
        }

        XCTAssertEqual(font, UIFont.preferredFont(forTextStyle: .title2),
                       "Species segmented control should have a custom font for its normal state")
    }

    func testSearchButton() {
        loadComponents()

        guard let button = searchButton,
            let target = button.target
            else {
                return XCTFail("Navigation bar should have a right bar button item with a target")
        }

        XCTAssertEqual(button.title, "Search",
                       "Search button should exist and have correct title")
        XCTAssertFalse(button.isEnabled,
                       "Search button should not be enabled by default")

        XCTAssertTrue(
            target.isKind(of: NSClassFromString("UIStoryboardShowSegueTemplate")!),
            "Search button target should be a show segue template"
        )

        guard let template = controller.segueTemplate(
            identifiedBy: SearchWorkflow.SegueIdentifiers.performSearch
            ),
            template.destinationSceneIdentifier == "SearchResultsScene"
            else {
                return XCTFail("The controller should have a segue to transition to the search results scene")
        }

        XCTAssertTrue(target === template.rawTemplate,
                      "The buttons target should be a show segue")
    }

    // State-View Coordination

    func testDefaultViewConfiguration() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()
        loadComponents()

        assert(controller.userLocationResolution == .unknown)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with unknown resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with unknown resolution")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with unknown resolution")
    }

    func testViewConfigurationForUnknownLocationResolution() {
        loadComponents()
        controller.transition(to: .unknown)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with unknown resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with unknown resolution")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with unknown resolution")
    }

    func testViewConfigurationForAllowedLocationResolution() {
        loadComponents()
        controller.transition(to: .allowed)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with allowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with allowed resolution")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with allowed resolution")
    }

    func testViewConfigurationForDisallowedLocationResolution() {
        loadComponents()
        controller.transition(to: .disallowed)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with disallowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with disallowed resolution")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                       "Actionable message view should not be hidden with disallowed resolution")

        guard let label = controller.actionableMessageLabel,
            let button = controller.actionableMessageButton
            else {
                return XCTFail("Controller should have an actionable message view with a label and a button")
        }

        XCTAssertEqual(
            label.text,
            "Looks like you're in a top secret location. In order to find the pets closest to you, AdoptR needs to know where you are.",
            "Actionable message label should be configured correctly for disallowed resolution"
        )
        XCTAssertEqual(button.title(for: .normal), "Open Settings",
                       "Actionable message button should be configured correctly for disallowed resolution")

        guard let action = button.actions(forTarget: controller, forControlEvent: .touchUpInside)?
            .onlyElement
            else {
                return XCTFail("The button's action should target the controller")
        }

        XCTAssertEqual(action, NSStringFromSelector(#selector(LocationController.continueLocationResolution)),
                       "Tapping the button should open the settings app")
    }

    func testViewConfigurationForInProgressLocationResolution() {
        loadComponents()
        controller.transition(to: .resolving)

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden with resolving resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with resolving resolution")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with resolving resolution")
    }

    func testViewConfigurationForSuccessfulLocationResolution() {
        loadComponents()
        controller.transition(to: .resolved(location: SamplePlacemarks.denver))

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with a resolved location")
        XCTAssertFalse(controller.resolvedLocationView.isHidden,
                       "Resolved location view should not be hidden with a resolved location")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with a resolved location")

        XCTAssertEqual(controller.resolvedLocationView.label.text, "Denver, CO",
                       "Resolving location label should be configured correctly for resolving resolution")
    }

    func testViewConfigurationForFailedLocationResolution() {
        loadComponents()

        controller.locationManager(locationManager, didFailWithError: LocationResolutionError.unknownError)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with resolution failure")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with resolution failure")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                       "Actionable message view should not be hidden with resolution failure")

        XCTAssertEqual(
            controller.actionableMessageLabel.text,
            "We seem to be having trouble locating you.",
            "Actionable message label should be configured correctly for resolution failure"
        )
        XCTAssertEqual(
            controller.actionableMessageButton.title(for: .normal),
            "Find My Location",
            "Actionable message button should be configured correctly for resolution failure"
        )
    }

    func testSceneContinuesLocationResolutionWhenDisallowed() {
        loadComponents()

        controller.transition(to: .disallowed)

        controller.continueLocationResolution()

        let application = UIApplication.shared
        guard application.openUrlCalled,
            application.openUrlUrl == URL(string: UIApplicationOpenSettingsURLString)!
            else {
                return XCTFail("The settings action should open the settings screen after dismissing the alert")
        }
    }

    // MARK:- State Transition Consequences

    func testTransitioningFromUnknownToDisallowed() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "User location resolution should be unknown when location permission is not determined")

        locationManager.requestWhenInUseAuthorizationCalled = false

        controller.transition(to: .disallowed)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with disallowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with disallowed resolution")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                       "Actionable message view should not be hidden with disallowed resolution")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertFalse(locationManager.requestLocationCalled,
                       "Should not request location")
    }

    func testTransitioningFromUnknownToResolving() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "User location resolution should be unknown when location permission is not determined")

        locationManager.requestWhenInUseAuthorizationCalled = false

        controller.transition(to: .resolving)

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden with resolving state")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with resolving state")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with resolving state")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Should request location when appearing with resolving state")
    }

    func testTransitioningFromDisallowedToUnknown() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location services are not available")

        locationManager.requestWhenInUseAuthorizationCalled = false

        CLLocationManager.stubbedLocationServicesEnabled = true
        controller.transition(to: .unknown)

        XCTAssertTrue(locationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request when in use authorization when state transitions to unknown")
        XCTAssertFalse(locationManager.requestLocationCalled,
                       "Should not request location")
    }

    func testTransitioningFromDisallowedToResolving() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location services are not available")

        CLLocationManager.stubbedLocationServicesEnabled = true
        controller.transition(to: .resolving)

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Location manager should request location when state transitions to resolving")
    }

    func testTransitioningFromAllowedToDisallowed() {
        loadComponents()

        locationManager.requestLocationCalled = false

        XCTAssertEqual(controller.userLocationResolution, .allowed,
                       "User location resolution should be allowed when location permission is granted")

        controller.transition(to: .disallowed)

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with disallowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with disallowed resolution")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                       "Actionable message view should not be hidden with disallowed resolution")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertFalse(locationManager.requestLocationCalled,
                       "Should not request location")
    }

    func testTransitioningFromAllowedToResolving() {
        loadComponents()

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should be resolving when appearing as allowed")

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden with resolving state")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with resolving state")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with resolving state")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Location manager should request location when state transitions to resolving")
    }

    func testTransitioningFromResolvingToResolved() {
        loadComponents()

        controller.viewDidAppear(false)

        locationManager.requestLocationCalled = false

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should be resolving when appearing as allowed")

        controller.transition(to: .resolved(location: SamplePlacemarks.denver))

        XCTAssertTrue(searchButton.isEnabled,
                      "Search button should be enabled when the user has a resolved location")

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with resolved state")
        XCTAssertFalse(controller.resolvedLocationView.isHidden,
                       "Resolved location view should not be hidden with resolved state")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with resolved state")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertFalse(locationManager.requestLocationCalled,
                       "Should not request location")
    }

    func testTransitioningFromFailureToDisallowed() {
        loadComponents()

        controller.transition(to: .resolutionFailure(error: SampleError()))

        CLLocationManager.stubbedLocationServicesEnabled = false

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Location resolution state should be disallowed when location is unavailable")

        XCTAssertTrue(controller.resolvingLocationView.isHidden,
                      "Resolving location view should be hidden with disallowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with disallowed resolution")
        XCTAssertFalse(controller.actionableMessageView.isHidden,
                       "Actionable message view should not be hidden with disallowed resolution")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertFalse(locationManager.requestLocationCalled,
                       "Should not request location")
    }

    func testTransitioningFromFailureToResolving() {
        loadComponents()

        controller.transition(to: .resolutionFailure(error: SampleError()))

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "Location resolution state should be resolving when location is available")

        XCTAssertFalse(controller.resolvingLocationView.isHidden,
                       "Resolving location view should not be hidden with disallowed resolution")
        XCTAssertTrue(controller.resolvedLocationView.isHidden,
                      "Resolved location view should be hidden with disallowed resolution")
        XCTAssertTrue(controller.actionableMessageView.isHidden,
                      "Actionable message view should be hidden with disallowed resolution")

        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should request not request authorization")
        XCTAssertTrue(locationManager.requestLocationCalled,
                      "Should request location")
    }

    // MARK: - Location Permission

    func testApplicationProvidesWhenInUseAuthorizationRequestString() {
        guard let infoDictionary = Bundle(for: LocationController.self).infoDictionary,
            let whenInUsePrompt = infoDictionary["NSLocationWhenInUseUsageDescription"] as? String
            else {
                return XCTFail("Bundle should include a description for displaying to the user to request location when in use")
        }

        XCTAssertEqual(whenInUsePrompt, "Your location will allow us to search local shelters for pets near you!",
                       "Prompt should be correct")
    }

    // MARK:- Requesting Location

    func testControllerIsLocationManagerDelegate() {
        loadComponents()

        XCTAssertTrue(locationManager.delegate === controller,
                      "Controller should be the location manager's delegate")
    }

    // MARK:- Geocoding

    func testGeocoderIsCalledOnLocationReceipt() {
        loadComponents()
        let expectedLocation = CLLocation(latitude: 1, longitude: 1)
        let locations = [
            CLLocation(latitude: 0, longitude: 0),
            CLLocation(latitude: 0, longitude: 0),
            expectedLocation
        ]

        controller.locationManager(locationManager, didUpdateLocations: locations)

        guard geocoder.reverseGeocodeLocationCalled,
            let location = geocoder.reverseGeocodeLocationLocation,
            location == expectedLocation
            else {
                return XCTFail("Geocoder should be called with the last location received")
        }
    }

    func testGeocodingWithError() {
        loadComponents()

        controller.locationManager(
            locationManager,
            didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)]
        )

        guard let handler = geocoder.reverseGeocodeLocationCompletionHandler else {
            return XCTFail("Geocoder should be called with the last location received")
        }

        handler(nil, LocationResolutionError.noLocationsFound)

        XCTAssertEqual(
            controller.userLocationResolution,
            .resolutionFailure(error: LocationResolutionError.noLocationsFound),
            "Failure to geocode should update user location resolution"
        )
        XCTAssertFalse(searchButton.isEnabled,
                       "Search button should not be enabled if there is no resolved location")
    }

    func testSuccessfulGeocoding() {
        loadComponents()

        controller.locationManager(
            locationManager,
            didUpdateLocations: [CLLocation(latitude: 0, longitude: 0)]
        )

        guard let handler = geocoder.reverseGeocodeLocationCompletionHandler else {
            return XCTFail("Geocoder should be called with the last location received")
        }

        handler([SamplePlacemarks.denver, SamplePlacemarks.detroit], nil)

        XCTAssertEqual(
            controller.userLocationResolution,
            .resolved(location: SamplePlacemarks.denver),
            "Successful geocoding should update user location resolution with the first available placemark"
        )
        XCTAssertTrue(searchButton.isEnabled,
                      "Search button should be enabled if there is a resolved location")
    }

    func testGeocodingCancelledWhenSceneDisappears() {
        loadComponents()

        geocoder.beginStubbingIsGeocoding(with: true)

        CLGeocoder.CancelGeocodeSpyController.createSpy(on: geocoder)!.spy {
            controller.viewWillDisappear(false)

            XCTAssertTrue(geocoder.cancelGeocodeCalled,
                          "Geocoding should be cancelled when scene disappears before task is complete")
        }

        geocoder.endStubbingIsGeocoding()
    }

    // MARK:- Favorites Button

    func testFavoritesButtonWithSavedFavorites() {
        addCatsToRealm()
        loadComponents()
        controller.viewWillAppear(false)

        guard let button = favoritesButton,
            let target = button.target
            else {
                return XCTFail("Navigation bar should have a left bar button item with a target")
        }

        XCTAssertEqual(button.title, "Favorites",
                       "Favorites button should exist and have correct title")
        XCTAssertTrue(button.isEnabled,
                      "Favorites button should be enabled if there are saved favorites")

        XCTAssertTrue(
            target.isKind(of: NSClassFromString("UIStoryboardShowSegueTemplate")!),
            "Favorite button target should be a show segue template"
        )

        guard let template = controller.segueTemplate(identifiedBy: "ShowFavorites"),
            template.destinationSceneIdentifier == "FavoritesScene"
            else {
                return XCTFail("The controller should have a segue to transition to the favorites scene")
        }

        XCTAssertTrue(target === template.rawTemplate,
                      "The buttons target should be a show segue")
    }

    func testFavoritesButtonWithNoDatabase() {
        InjectionMap.realm = nil
        controller.viewWillAppear(false)

        XCTAssertNil(controller.navigationItem.leftBarButtonItem,
                     "Favorites button should not be displayed in the navigation bar if there is no way to save favorites")
    }

    func testFavoritesButtonWithoutSavedFavorites() {
        loadComponents()
        controller.viewWillAppear(false)

        XCTAssertNil(controller.navigationItem.leftBarButtonItem,
                     "Favorites button should not be displayed in the navigation bar if there are no saved favorites")
    }

    func testFavoritesButtonIsReAddedAfterFavoriting() {
        loadComponents()

        controller.viewWillAppear(false)

        addCatsToRealm()
        controller.viewWillAppear(false)

        XCTAssertEqual(controller.navigationItem.leftBarButtonItem, favoritesButton,
                       "Favorites button should be displayed in the navigation bar if there are favorites")
    }

    func testSceneHasSpeciesSelectionControl() {
        loadComponents()

        guard let control = controller.speciesSelectionControl,
            control.numberOfSegments == 3
            else {
                return XCTFail("The scene should have a segmented control for selecting the search species")
        }

        let expectedTitles = ["Cat", "Dog", "Any"]
        let actualTitles = (0 ..< control.numberOfSegments).flatMap {
            control.titleForSegment(at: $0)
        }

        XCTAssertEqual(actualTitles, expectedTitles,
                       "Species selection control should have the correct titles in the correct order")

        XCTAssertEqual(control.selectedSegmentIndex, 0,
                       "The first segment should be selected by default")
    }

    func testSceneIndicatesSpeciesSelection() {
        loadComponents()

        XCTAssertEqual(controller.selectedSpecies, .cat,
                       "The cat species should correspond to the first segment")

        controller.speciesSelectionControl.selectedSegmentIndex = 1
        XCTAssertEqual(controller.selectedSpecies, .dog,
                       "The dog species should correspond to the second segment")

        controller.speciesSelectionControl.selectedSegmentIndex = 2
        XCTAssertNil(controller.selectedSpecies,
                     "The 'any' species selection should correspond to the final segment")
    }

    func testSegueToSearchScene() {
        loadComponents()

        let destination = AnimalCardsViewController()
        let segue = UIStoryboardSegue(
            identifier: SearchWorkflow.SegueIdentifiers.performSearch,
            source: controller,
            destination: destination
        )

        let placemark = SamplePlacemarks.denver
        let resolution = UserLocationResolution.resolved(location: placemark)
        controller.transition(to: resolution)

        controller.speciesSelectionControl.selectedSegmentIndex = 1

        controller.prepare(for: segue, sender: controller)

        XCTAssertEqual(
            destination.searchParameters.zipCode.rawValue,
            placemark.postalCode,
            "Segueing to an animal list scene should pass the expected zip code"
        )

        XCTAssertEqual(
            destination.searchParameters.species,
            .dog,
            "Segueing to an animal list scene should pass the expected species or lack thereof"
        )
    }

}

extension LocationControllerTests {
    func addCatsToRealm(_ file: StaticString = #file, _ line: UInt = #line) {
        try? realm.write {
            cats.forEach {
                realm.add($0.managedObject, update: true)
            }
        }

        XCTAssertEqual(realm.objects(AnimalObject.self).count, cats.count,
                       "Correct number of animals should be persisted", file: file, line: line)
    }
}
extension UserLocationResolution: Equatable {

    public static func == (lhs: UserLocationResolution, rhs: UserLocationResolution) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
             (.disallowed, .disallowed),
             (.allowed, .allowed),
             (.resolving, .resolving):
            return true

        case (.resolutionFailure(_), .resolutionFailure(_)):
            return true

        case (.resolved(let leftPlacemark), .resolved(let rightPlacemark)):
            return leftPlacemark == rightPlacemark

        default:
            return false
        }
    }

}
