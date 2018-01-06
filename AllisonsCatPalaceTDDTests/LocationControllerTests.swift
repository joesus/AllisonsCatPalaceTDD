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

        switch controller.userLocationResolution {
        case .unknown:
            break
        default:
            XCTFail("Controller should have a user location resolution with an initial state of unknown when location services are enabled but authorization status is unknown")
        }
    }

    func testUserLocationResolutionForEnabledAndAuthorizedLocationServices() {
        loadController()

        switch controller.userLocationResolution {
        case .allowed:
            break
        default:
            XCTFail("Controller should have a user location resolution with an initial state of allowed if location services are enabled and authorized")
        }
    }

    func testUserLocationResolutionForDisabledLocationServices() {
        CLLocationManager.stubbedLocationServicesEnabled = false
        loadController()

        switch controller.userLocationResolution {
        case .disallowed:
            break
        default:
            XCTFail("Controller should have a user location resolution with an initial state of disallowed if location services are disabled")
        }
    }

    func testUserLocationResolutionForUnauthorizedPermissions() {
        CLLocationManager.stubbedAuthorizationStatus = .denied
        loadController()

        switch controller.userLocationResolution {
        case .disallowed:
            break
        default:
            XCTFail("Controller should have a user location resolution with an initial state of disallowed if location services authorization has been denied")
        }
    }

    func testViewDidLoad() {
        UIViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            controller.viewDidLoad()
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

    }

        }

    }







    }






    }



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
