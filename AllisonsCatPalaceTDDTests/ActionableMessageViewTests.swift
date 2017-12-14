//
//  ActionableMessageViewTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

@IBDesignable
class ActionableMessageViewTests: XCTestCase {
    
    func testContainsAView() {
        let bundle = Bundle(for: ActionableMessageView.self)
        guard let _ = bundle.loadNibNamed("ActionableMessageView", owner: ActionableMessageView().self)?.first as? UIView else {
            return XCTFail("Actionable message view did not contain a UIView")
        }
    }

    func testInitializingWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        XCTAssertFalse(ActionableMessageView(frame: frame).subviews.isEmpty,
                       "Actionable message view should add subviews from nib when instantiated in code")
    }

    func testIsIBDesignable() {
        let view = ActionableMessageView()
        view.subviews.forEach { $0.removeFromSuperview() }
        XCTAssertEqual(view.subviews, [],
                       "Actionable message view should have all subviews removed")
        view.prepareForInterfaceBuilder()
        XCTAssertFalse(view.subviews.isEmpty,
                       "Actionable message view should add subviews from nib when prepared for interface builder")
    }

    func testHasMessage() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ActionableMessageView(frame: frame)
        guard let message = view.messageLabel else {
            return XCTFail("Actionable message view should contain a label for displaying a message")
        }

        XCTAssertEqual(message.font, UIFont.preferredFont(forTextStyle: .body),
                       "The message should have a body text style so that it can display larger sizes when needed")
        XCTAssertEqual(message.numberOfLines, 0,
                       "The message should have number of lines set to zero so that it display long text on multiple lines.")
        XCTAssertEqual(message.lineBreakMode, .byWordWrapping,
                       "The message should have line break mode set to word wrap so that it can display long text on multiple lines.")
        XCTAssertFalse(message.isHidden,
                       "The message should not be hidden")
    }

    func testHasButton() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ActionableMessageView(frame: frame)
        guard let button = view.button else {
            return XCTFail("Actionable message view should contain a button")
        }

        XCTAssertFalse(button.isHidden,
                       "The button should not be hidden")
        XCTAssertTrue(button.isEnabled,
                      "The button should be enabled")

        guard let action = button.actions(
            forTarget: view,
            forControlEvent: .touchUpInside
            )?.first
            else {
                return XCTFail("The button should have an associated action")
        }

        XCTAssertEqual(action, #selector(ActionableMessageView.buttonTapped).description,
                       "The button should notify the view of the user's intent to find location")
    }

    func testHasDelegate() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ActionableMessageView(frame: frame)
        var mockDelegate: MockButtonTapDelegate? = MockButtonTapDelegate()
        view.delegate = mockDelegate

        view.buttonTapped()

        XCTAssertTrue(mockDelegate!.buttonTappedCalled,
                      "Actionable message view should notify the delegate on button taps")

        mockDelegate = nil

        XCTAssertNil(view.delegate,
                     "Delegate must be a weak reference")
    }

    func testConvenienceInitSetsLabelAndButton() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let view = ActionableMessageView(frame: frame)

        let expectedMessage = "A message"
        let expectedButtonTitle = "A button title"
        view.set(message: expectedMessage, actionTitle: expectedButtonTitle)

        XCTAssertEqual(view.messageLabel.text, expectedMessage,
                       "Actionable message view should have a convenience method for setting the displayed message")

        XCTAssertEqual(view.messageLabel.text, expectedMessage,
                       "Actionable message view should have a convenience method for setting the displayed button's title")
    }

}

class MockButtonTapDelegate: ButtonTapDelegate {
    var buttonTappedCalled = false
    func buttonTapped() {
        buttonTappedCalled = true
    }
}
