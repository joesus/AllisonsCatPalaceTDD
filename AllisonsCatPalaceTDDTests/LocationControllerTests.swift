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
import MapKit
import CoreLocation
import XCTest

class LocationControllerTests: XCTestCase {
    var controller: LocationController!
    var textField: UITextField!
    var delegate: UITextFieldDelegate!
    var geocoder: CLGeocoder!
    var geocoderSpy: Spy?

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LocationController.self))
        controller = storyboard.instantiateViewController(withIdentifier: "LocationController") as? LocationController

        controller.loadViewIfNeeded()

        textField = controller.zipCodeField
        delegate = controller
        geocoder = controller.geocoder

        geocoderSpy = CLGeocoder.ForwardGeocodeAddressSpyController.createSpy(on: geocoder)
        geocoderSpy?.beginSpying()
    }

    override func tearDown() {
        geocoderSpy?.endSpying()

        super.tearDown()
    }

    func testZipCodeField() {
        guard let field = textField else {
            return XCTFail("Location controller should have a zip code field")
        }

        verifyTextFieldIsEmpty(field,
                               "ZipCode field should be empty by default")
        XCTAssertEqual(field.borderStyle, .roundedRect,
                       "Zip code field should have rounded border")
        XCTAssertEqual(field.keyboardType, .numberPad,
                       "Zip code field should only accept numeric input")
        XCTAssertEqual(field.layer.cornerRadius, 4,
                       "Zip code field's corner radius should be four points")
        XCTAssertEqual(field.layer.borderWidth, 1,
                       "Zip code field's border width should be one point")
        XCTAssertEqual(field.layer.borderColor, UIColor.lightGray.cgColor,
                       "Zip code field's border color should be light gray")
        XCTAssertTrue(field.delegate === controller,
                      "Zip code field's delegate should be the controller")
    }

    func testZipCodeFieldNumbersOnly() {
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "0"),
                      "Zip code field should accept numeric input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "a"),
                       "Zip code field should not accept alphabetic input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "!"),
                       "Zip code field should not accept special character input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "@"),
                       "Zip code field should not accept special character input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "."),
                       "Zip code field should not accept special character input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: " "),
                       "Zip code field should not accept white space input")

        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "\n"),
                       "Zip code field should not accept newline input")
    }

    func testZipCodeFieldCharacterLimit() {
        textField.text = ""
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(), replacementString: "8"))

        textField.text = "8"
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: "0"))

        textField.text = "80"
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: "2"))

        textField.text = "802"
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(location: 3, length: 0), replacementString: "2"))

        textField.text = "8022"
        XCTAssertTrue(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(location: 4, length: 0), replacementString: "0"))

        textField.text = "80220"
        XCTAssertFalse(delegate.textField!(textField, shouldChangeCharactersIn: NSRange(location: 5, length: 0), replacementString: "8"))
    }

    func testZipCodeFieldBeginsEditing() {
        // resets borderColor
        textField.layer.borderColor = UIColor.green.cgColor
        XCTAssertEqual(textField.layer.borderColor, UIColor.green.cgColor,
                       "Zip code field's border color should be green")

        delegate.textFieldDidBeginEditing?(textField)
        XCTAssertEqual(textField.layer.borderColor, UIColor.lightGray.cgColor,
                       "Zip code field's border color should be reset to light gray on beginning text editing")

        // stops spinner
        controller.activityIndicator.startAnimating()
        XCTAssertTrue(controller.activityIndicator.isAnimating,
                      "Activity indicator should be animating")
        delegate.textFieldDidBeginEditing?(textField)
        XCTAssertFalse(controller.activityIndicator.isAnimating,
                       "Activity indicator should stop animating on beginning text editing")
    }

    func testZipCodeFieldEndsEditingAtFiveCharacters() {
        // textField.endEditing(_ force:) doesn't trigger the delegate method
        // not sure how to test that the code in didEndEditing is being called
        // if I can't programmatically trigger this relationship
    }

    func testZipCodeFieldResignsFirstResponderWhenDoneEditing() {
        UITextField.ResignFirstResponderSpyController.createSpy(on: textField)?.spy {
            textField.text = "80220"
            delegate.textFieldDidEndEditing!(textField)

            XCTAssertTrue(textField.resignFirstResponderCalled,
                          "Textfield should resign first responder when done editing")
        }
    }

    func testZipCodeFieldEndsEditingIfChangesCharactersWhenAlreadyAtCharacterLimit() {
        // textField.endEditing(_ force:) doesn't trigger the delegate method
        // not sure how to test that the code in didEndEditing is being called
        // if I can't programmatically trigger this relationship
    }

    func testZipCodeFieldGeocodesAtFiveCharacters() {
        textField.text = "80220"
        delegate.textFieldDidEndEditing!(textField)
        XCTAssertTrue(geocoder.forwardGeocodeAddressCalled)
    }

    func testActivityIndicatorHiddenByDefault() {
        XCTAssertTrue(controller.activityIndicator.isHidden,
                      "Activity indicator should be hidden by default")
        XCTAssertFalse(controller.activityIndicator.isAnimating,
                       "Activity indicator should not be animating by default")
    }

    func testGeocodingInProgress() {
        textField.text = "80220"
        delegate.textFieldDidEndEditing!(textField)

        XCTAssertFalse(controller.activityIndicator.isHidden,
                       "Activity indicator should not be hidden while geocoding")
        XCTAssertTrue(controller.activityIndicator.isAnimating,
                      "Activity indicator should animate while geocoding")

        XCTAssertFalse(textField.isUserInteractionEnabled,
                       "User interaction should be disabled when geocoding is in progress")
    }

    func testGeocodingCompleted() {
        textField.text = "80220"
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], nil)

        XCTAssertTrue(controller.activityIndicator.isHidden,
                      "Activity indicator should be hidden when geocoding is not in progress")
        XCTAssertFalse(controller.activityIndicator.isAnimating,
                       "Activity indicator should not be animating when geocoding is not in progress")
        XCTAssertTrue(textField.isUserInteractionEnabled,
                      "User interaction should be enabled when geocoding is not in progress")
    }


    func testGeocodingWithEmptyResultsAndError() {
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], GeocodingError.noLocationsFound)

        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor,
                       "Zip code field should have red border on error")
        // TODO: maybe show an error message depending on the type of error that comes back?
    }

    func testGeocodingWithEmptyResultsAndNoError() {
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], nil)

        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor,
                       "Zip code field should have red border when there are no results")
        // TODO: use custom error for empty results to show the message
    }

    func testGeocodingWithNonEmptyResultsAndError() {
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], GeocodingError.noLocationsFound)

        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor,
                       "Zip code field should have red border when there is an error regardless of results")
        // TODO: show the error? Ignore the error if you have the info you want already?
    }

    func testGeocodingWithNonEmptyResultsAndNoError() {
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertEqual(textField.layer.borderColor, UIColor.lightGray.cgColor,
                       "Zip code field should have non-error color border when there are results and no error")
    }

    func testSuccessfulGeocodingShowsList() {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navController.addChildViewController(controller)

        let performSegueSpy = UIViewController.PerformSegueSpyController.createSpy(on: controller)
        let showSpy = UIViewController.ShowSpyController.createSpy(on: navController)

        performSegueSpy?.beginSpying()
        showSpy?.beginSpying()

        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertTrue(navController.showCalled,
                      "Navigation controller should call show when geocoding is successful")
        XCTAssertTrue(navController.showController is CatListController,
                      "Navigation controller should show cat list controller when geocoding is successful")

        XCTAssertTrue(controller.performSegueCalled,
                      "Controller should perform segue when geocoding is successful")
        XCTAssertEqual(controller.performSegueIdentifier, "ShowCatListController",
                       "Controller should use correct segue identifier to show cat list controller")

        performSegueSpy?.endSpying()
        showSpy?.endSpying()
    }
}

// Workaround for getting a placemark instance to use in the Geocoder handler
extension LocationControllerTests {
    var placemark: CLPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20), addressDictionary: ["City": "Palo Alto", "State": "CA"])
    }
}
