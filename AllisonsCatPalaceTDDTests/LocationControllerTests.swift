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
import XCTest

class LocationControllerTests: XCTestCase {
    var controller: LocationController!
    var delegate: UITextFieldDelegate!
    var geocoder: CLGeocoder!
    var geocoderSpy: Spy?
    var performSegueSpy: Spy?
    var showSpy: Spy?
    var navController: UINavigationController!
    var placemark: MutablePlacemark = {
        let mark = MutablePlacemark()
        mark.postalCode = "80220"
        return mark
    }()

    override func setUp() {
        super.setUp()


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

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController

        performSegueSpy = UIViewController.PerformSegueSpyController.createSpy(on: controller)
        showSpy = UIViewController.ShowSpyController.createSpy(on: navController)

        performSegueSpy?.beginSpying()
        showSpy?.beginSpying()
    }

    private func loadController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LocationController.self))
        controller = storyboard.instantiateViewController(withIdentifier: "LocationController") as? LocationController
    }

    override func tearDown() {
        geocoderSpy?.endSpying()
        performSegueSpy?.endSpying()
        showSpy?.endSpying()
        CLLocationManager.endStubbingAuthorizationStatus()
        CLLocationManager.endStubbingLocationServicesEnabled()


        super.tearDown()
    }

    func testUserLocationResolutionForFirstLaunch() {
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "Controller should have a user location resolution with an initial state of unknown when location services are enabled but authorization status is unknown")
    }

    func testUserLocationResolutionForEnabledAndAuthorizedLocationServices() {
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .allowed,
                       "Controller should have a user location resolution with an initial state of allowed if location services are enabled and authorized")
    }

    func testUserLocationResolutionForDisabledLocationServices() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should have a user location resolution with an initial state of disallowed if location services are disabled")
    }

    func testUserLocationResolutionForUnauthorizedPermissions() {
        CLLocationManager.stubbedAuthorizationStatus = .denied
        loadController()

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "Controller should have a user location resolution with an initial state of disallowed if location services authorization has been denied")
    }

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
                      "ViewDidAppear should call viewDidAppear on controller")
        }
    }

    func testResolvingLocationView() {
        loadComponents()

        guard let view = controller.resolvingLocationView,
            let activityIndicator = view.activityIndicator,
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
            let label = view.label
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
            )?.first
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

        guard let template = controller.segueTemplate(identifiedBy: "ShowSearch"),
            template.destinationSceneIdentifier == "SearchResultsScene"
            else {
                return XCTFail("The controller should have a segue to transition to the search results scene")
        }

        XCTAssertTrue(target === template.rawTemplate,
                      "The buttons target should be a show segue")
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
        controller.transition(to: .resolutionFailure(error: GeocodingError.unknownError))

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

    func testLocationServicesPromptsWhenNotDetermined() {
        loadComponents()
        CLLocationManager.stubbedAuthorizationStatus = .notDetermined

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .unknown,
                       "User location resolution should be unknown when location permission is not determined")
        XCTAssertTrue(locationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request when in use authorization if status is not determined")
    }

    func testUserNotPromptedIfLocationServicesUnavailable() {
        loadComponents()
        CLLocationManager.stubbedLocationServicesEnabled = false

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location services are not available")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request when in use authorization if location services are not enabled")
    }

    func testLocationServicesDoesNotPromptWhenAuthorized() {
        loadComponents()
        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .resolving,
                       "User location resolution should be resolving when location permission is authorized")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if already authorized")
    }

    func testLocationServicesDoesNotPromptWhenPreviouslyDenied() {
        loadComponents()
        CLLocationManager.stubbedAuthorizationStatus = .denied

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location permission is denied")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if previously denied")
    }

    func testLocationServicesDoesNotPromptWhenRestricted() {
        loadComponents()
        CLLocationManager.stubbedAuthorizationStatus = .restricted

        controller.viewDidAppear(false)

        XCTAssertEqual(controller.userLocationResolution, .disallowed,
                       "User location resolution should be disallowed when location permission is restricted")
        XCTAssertFalse(locationManager.requestWhenInUseAuthorizationCalled,
                       "Location manager should not request authorization if user is restricted")
    }



        }
    }

        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "000")

        XCTAssertFalse(geocoder.forwardGeocodeAddressCalled,
                       "Geocoder should not be called with an invalid zip code")
    }

    func testGeocodingInProgress() {
    }

    func testGeocodingCompleted() {
    }

    func testGeocodingWithEmptyResultsAndError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        geocoder.forwardGeocodeAddressCompletionHandler?([], GeocodingError.noLocationsFound)

    }

    func testGeocodingWithEmptyResultsAndNoError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "80220")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], nil)

    }

    func testGeocodingWithNonEmptyResultsAndNoError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

    }

    func testViewWillDisappearCancelsGeocoding() {
// TODO - figure out why geocoder.isGeocoding always returns false in tests
//        CLGeocoder.CancelGeocodeSpyController.createSpy(on: geocoder)!.spy {
//            delegate.textFieldDidEndEditing!(textField) // end editing to kick off geocoding task
//
//            controller.viewWillDisappear(false)
//
//            XCTAssertTrue(geocoder.cancelGeocodeCalled,
//                          "Geocoding should be cancelled when view disappears before task is complete")
//        }
    }


    }

}

extension LocationControllerTests {
    func attemptGeocoding(withText text: String) {
    }

}
extension UserLocationResolution: Equatable {

    public static func == (lhs: UserLocationResolution, rhs: UserLocationResolution) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
            (.disallowed, .disallowed),
            (.allowed, .allowed),
            (.resolving, .resolving),
            (.resolutionFailure, .resolutionFailure):
            return true

        case (.resolved(let leftPlacemark), .resolved(let rightPlacemark)):
            return leftPlacemark == rightPlacemark

        default:
            return false
        }
    }

}
