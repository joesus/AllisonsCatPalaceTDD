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
    var textField: UITextField!
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

        SettingsManager.shared.clear() // Clears persisted zip code

        loadComponents()

        geocoderSpy = CLGeocoder.ForwardGeocodeAddressSpyController.createSpy(on: geocoder)
        geocoderSpy?.beginSpying()

        navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController

        performSegueSpy = UIViewController.PerformSegueSpyController.createSpy(on: controller)
        showSpy = UIViewController.ShowSpyController.createSpy(on: navController)

        performSegueSpy?.beginSpying()
        showSpy?.beginSpying()
    }

    override func tearDown() {
        geocoderSpy?.endSpying()
        performSegueSpy?.endSpying()
        showSpy?.endSpying()

        super.tearDown()
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

    func testBecomesFirstResponderOnAppearing() {
        replaceRootViewController(with: controller)
        controller.viewDidAppear(false)
        XCTAssertTrue(textField.isFirstResponder,
                      "Textfield should be first responder on view did appear")
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
        delegate.textFieldDidBeginEditing?(textField)
        XCTAssertFalse(controller.activityIndicator.isAnimating,
                       "Activity indicator should stop animating on beginning text editing")
    }

    func testZipCodeFieldEndsEditingAtFiveCharacters() {
        UITextField.ResignFirstResponderSpyController.createSpy(on: textField)?.spy {
            // Need to be in the window to becomeFirstResponder
            replaceRootViewController(with: controller)
            textField.becomeFirstResponder()

            textField.text = "80220"
            controller.textFieldDidChange(textField)

            XCTAssertTrue(textField.resignFirstResponderCalled,
                          "Textfield should resign first responder at five characters")
        }
    }

    func testGeocoderIsNotCalledWithoutValidZipCode() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "000")

        XCTAssertFalse(geocoder.forwardGeocodeAddressCalled,
                       "Geocoder should not be called with an invalid zip code")
    }

    func testZipCodeFieldGeocodesAtFiveCharacters() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "80220")

        XCTAssertTrue(geocoder.forwardGeocodeAddressCalled,
                      "Textfield should forward geocode when it ends editing")
    }

    func testActivityIndicatorHiddenByDefault() {
        XCTAssertTrue(controller.activityIndicator.isHidden,
                      "Activity indicator should be hidden by default")
        XCTAssertTrue(controller.activityIndicator.hidesWhenStopped,
                      "Activity indicator should hide when stopped")
    }

    func testGeocodingInProgress() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "80220")

        XCTAssertTrue(controller.activityIndicator.isAnimating,
                      "Activity indicator should animate while geocoding")

        XCTAssertFalse(textField.isUserInteractionEnabled,
                       "User interaction should be disabled when geocoding is in progress")
    }

    func testGeocodingCompleted() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "80220")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], nil)

        XCTAssertFalse(controller.activityIndicator.isAnimating,
                       "Activity indicator should not be animating when geocoding is not in progress")
        XCTAssertTrue(textField.isUserInteractionEnabled,
                      "User interaction should be enabled when geocoding is not in progress")
    }

    func testGeocodingWithEmptyResultsAndError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        geocoder.forwardGeocodeAddressCompletionHandler?([], GeocodingError.noLocationsFound)

        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor,
                       "Zip code field should have red border on error")
        // TODO: maybe show an error message depending on the type of error that comes back?
    }

    func testGeocodingWithEmptyResultsAndNoError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "80220")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([], nil)

        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor,
                       "Zip code field should have red border when there are no results")
        // TODO: use custom error for empty results to show the message
    }

    func testGeocodingWithNonEmptyResultsAndNoError() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertEqual(textField.layer.borderColor, UIColor.lightGray.cgColor,
                       "Zip code field should have non-error color border when there are results and no error")
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

    func testSuccessfulGeocodingWhenNotTopViewController() {
        navController.addChildViewController(controller)

        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        controller.removeFromParentViewController()

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertFalse(navController.showCalled,
                       "Navigation controller should not call show on a successful geocoding when location controller is not the top view controller")
        XCTAssertFalse(controller.performSegueCalled,
                       "Controller should not perform segue on successful geocoding when not top view controller")
    }

    func testSuccessfulGeocodingWhenTopViewController() {
        navController.addChildViewController(controller)

        replaceRootViewController(with: navController)

        attemptGeocoding(withText: "12345")

        // Find out why this one won't cooperate
        delegate.textFieldDidEndEditing!(textField)

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertTrue(navController.showCalled,
                      "Navigation controller should call show when geocoding is successful")
        XCTAssertTrue(navController.showController is AnimalCardsViewController,
                      "Navigation controller should show animal cards controller when geocoding is successful")

        XCTAssertTrue(controller.performSegueCalled,
                      "Controller should perform segue when geocoding is successful")
        XCTAssertEqual(controller.performSegueIdentifier, "ShowAnimalCardsViewController",
                       "Controller should use correct segue identifier to show animal cards controller")

        performSegueSpy?.endSpying()
        showSpy?.endSpying()
    }

    func testSavingToUserDefaults() {
        replaceRootViewController(with: controller)
        attemptGeocoding(withText: "12345")

        guard let handler = geocoder.forwardGeocodeAddressCompletionHandler else {
            return XCTFail("Geocoder should be called with a handler")
        }
        handler([placemark], nil)

        XCTAssertEqual(
            SettingsManager.shared.value(forKey: SettingsManager.Key.zipCode) as? String,
            "80220",
            "Geocoding should save zip code to settings"
        )
    }

    func testTextFieldDoesNotPrepopulateWithStoredZipCodeIfNotAvailable() {
        SettingsManager.shared.set(value: nil, forKey: .zipCode)

        controller.viewDidLoad()
        XCTAssertTrue(textField.text!.isEmpty,
                      "Textfield should not prepopulate from stored zip code if no zip code is stored")
    }

    func testTextFieldPrepopulatesOnViewDidLoadWithStoredZipCodeIfAvailable() {
        SettingsManager.shared.set(value: "12345", forKey: .zipCode)

        controller.viewDidLoad()
        XCTAssertEqual(textField.text, "12345",
                       "Textfield should prepopulate from stored zip code")
    }

    func testTextFieldPrepopulatesOnViewWillAppearWithStoredZipCodeIfAvailable() {
        SettingsManager.shared.set(value: "12345", forKey: .zipCode)

        controller.viewWillAppear(false)
        XCTAssertEqual(textField.text, "12345",
                       "Textfield should prepopulate from stored zip code")
    }
}

extension LocationControllerTests {
    func loadComponents() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LocationController.self))
        controller = storyboard.instantiateViewController(withIdentifier: "LocationController") as? LocationController
        controller.loadViewIfNeeded()

        textField = controller.zipCodeField
        delegate = controller
        geocoder = controller.geocoder
    }

    func attemptGeocoding(withText text: String) {
        textField.becomeFirstResponder()
        textField.text = text
        textField.resignFirstResponder()
    }

}
