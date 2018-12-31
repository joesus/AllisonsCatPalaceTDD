//
//  LocationResolutionControllerTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/16/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

// swiftlint:disable line_length type_body_length

@testable import AllisonsCatPalaceTDD
import XCTest

class LocationResolutionControllerTests: XCTestCase {

    var controller: LocationResolutionController!

    // swiftlint:disable:next weak_delegate
    var delegate: FakeLocationResolutionDelegate? = FakeLocationResolutionDelegate()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "LocationResolutionScene")
            as? LocationResolutionController

        controller.loadViewIfNeeded()
    }

    func testDelegate() {
        XCTAssertNil(controller.delegate,
                     "Delegate should be nil by default")

        controller.delegate = delegate
        delegate = nil

        XCTAssertNil(delegate, "Delegate should be held weakly by the controller")
    }

    func testActions() {
        let actions: [LocationResolutionDisplayState.Action] = [
            .goToSettings,
            .retry
        ]

        actions.forEach { action in
            switch action {
            case .goToSettings, .retry: break
            }
        }
    }

    func testStates() {
        let states: [LocationResolutionDisplayState] = [
            .resolving,
            .resolved(placemark: SamplePlacemarks.denver),
            .actionable(action: .retry)
        ]

        states.forEach { state in
            switch state {
            case .resolving, .resolved, .actionable: break
            }
        }
    }

    // MARK: - View Configuration

    func testSceneHasMainStackView() {
        guard let stackView = controller.mainStack else {
            return XCTFail("Controller should have a stack to hold the possible subviews")
        }

        let expectedStackContents: [UIView] = [
            controller.resolvingView!,
            controller.resolvedView!,
            controller.actionableView!
        ]

        XCTAssertEqual(stackView.arrangedSubviews, expectedStackContents,
                       "Controller's subviews should be enclosed in a stack in the proper order")
    }

    func testResolvingView() {
        guard let view = controller.resolvingView,
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
        XCTAssertEqual(label.numberOfLines, 0,
                       "Resolving location view's label should be allowed to grow")
        XCTAssertEqual(label.lineBreakMode, .byWordWrapping,
                       "Resolving location view's label should have line break mode set to wrapping words")
        XCTAssertFalse(label.isHidden,
                       "Resolving location view's label should not be hidden")
    }

    func testResolvedView() {
        guard let view = controller.resolvedView,
            let icon = view.icon,
            let label = view.label,
            let button = view.button
            else {
                return XCTFail("Controller should have a view with an icon and label for indicating that location has been resolved")
        }

        XCTAssertTrue(view.isHidden,
                      "Resolved view should be hidden by default")
        XCTAssertEqual(icon.image, #imageLiteral(resourceName: "location-pin"),
                       "Resolved view should have an indicator image of a pin")

        XCTAssertEqual(label.font, .systemFont(ofSize: 24),
                       "Resolved view's label should have 24 point font")
        XCTAssertEqual(label.numberOfLines, 1,
                       "Resolved view's label should have number of lines set to one")
        XCTAssertEqual(label.lineBreakMode, .byTruncatingTail,
                       "Resolved view's label should have line break mode set to truncate tail")
        XCTAssertFalse(label.isHidden,
                       "Resolved view's label should not be hidden")
        XCTAssertEqual(button.title(for: .normal), "Update",
                       "Resolved view's button should have the correct text")

        guard let action = button.actions(
            forTarget: controller,
            forControlEvent: .touchUpInside
            )?.onlyElement
            else {
                return XCTFail("The button should have an associated action")
        }

        XCTAssertEqual(action, #selector(LocationResolutionController.performAction).description,
                       "The button should notify the view of the user's intent to find location")
    }

    func testActionableView() {
        guard let view = controller.actionableView,
            let label = controller.actionableLabel,
            label.superview === view,
            let button = controller.actionableButton,
            button.superview === view
            else {
                return XCTFail("Controller should have an actionable view with a label and a button")
        }

        XCTAssertTrue(view.isHidden,
                      "Actionable view should be hidden by default")
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

        XCTAssertEqual(action, #selector(LocationResolutionController.performAction).description,
                       "The button should notify the view of the user's intent to find location")
    }

    func testViewConfigurationForInProgressLocationResolution() {
        showSubviews()

        controller.configure(for: .resolving)

        XCTAssertFalse(controller.resolvingView.isHidden,
                       "Resolving view should not be hidden when resolving resolution")
        XCTAssertTrue(controller.resolvedView.isHidden,
                      "Resolved view should be hidden when resolving resolution")
        XCTAssertTrue(controller.actionableView.isHidden,
                      "Actionable view should be hidden when resolving resolution")
    }

    func testViewConfigurationForSuccessfulLocationResolution() {
        showSubviews()

        controller.configure(for: .resolved(placemark: SamplePlacemarks.denver))

        XCTAssertTrue(controller.resolvingView.isHidden,
                      "Resolving view should be hidden with a resolved location")
        XCTAssertFalse(controller.resolvedView.isHidden,
                       "Resolved location view should not be hidden with a resolved location")
        XCTAssertTrue(controller.actionableView.isHidden,
                      "Actionable message view should be hidden with a resolved location")

        XCTAssertEqual(
            controller.resolvedView.label.text,
            DisplayableLocation(placemark: SamplePlacemarks.denver).displayableString,
            "Resolving location label should be configured correctly for resolving resolution"
        )
    }

    func testViewConfigurationForGoToSettingsActionableState() {
        controller.delegate = delegate
        showSubviews()

        controller.configure(for: .actionable(action: .goToSettings))

        XCTAssertTrue(controller.resolvingView.isHidden,
                      "Resolving view should be hidden when action is go to settings")
        XCTAssertTrue(controller.resolvedView.isHidden,
                      "Resolved view should be hidden when action is go to settings")
        XCTAssertFalse(controller.actionableView.isHidden,
                       "Actionable view should not be hidden when action is go to settings")

        guard let label = controller.actionableLabel,
            let button = controller.actionableButton
            else {
                return XCTFail("Controller should have an actionable message view with a label and a button")
        }

        XCTAssertEqual(
            label.text,
            """
            Looks like you're in a top secret location.
            In order to find the pets closest to you, AdoptR needs to know where you are.
            """,
            "Actionable message label should be configured correctly when action is go to settings"
        )
        XCTAssertEqual(button.title(for: .normal), "Open Settings",
                       "Actionable message button should be configured correctly when action is go to settings")

        controller.performAction()
        XCTAssertEqual(delegate?.capturedAction, .goToSettings,
                       "Tapping the actionable button should inform the delegate to go to settings")

        delegate?.capturedAction = nil
        controller.performAction()
        XCTAssertNil(delegate?.capturedAction,
                     "Tapping the actionable button again should not inform the delegate of anything")
    }

    func testViewConfigurationForRetryActionableState() {
        controller.delegate = delegate
        showSubviews()

        controller.configure(for: .actionable(action: .retry))

        XCTAssertTrue(controller.resolvingView.isHidden,
                      "Resolving view should be hidden when action is go to settings")
        XCTAssertTrue(controller.resolvedView.isHidden,
                      "Resolved view should be hidden when action is go to settings")
        XCTAssertFalse(controller.actionableView.isHidden,
                       "Actionable view should not be hidden when action is go to settings")

        guard let label = controller.actionableLabel,
            let button = controller.actionableButton
            else {
                return XCTFail("Controller should have an actionable message view with a label and a button")
        }

        XCTAssertEqual(
            label.text,
            "We seem to be having trouble locating you.",
            "Actionable message label should be configured correctly when action is retry"
        )
        XCTAssertEqual(button.title(for: .normal), "Find My Location",
                       "Actionable message button should be configured correctly when action is retry")

        controller.performAction()
        XCTAssertEqual(delegate?.capturedAction, .retry,
                       "Tapping the actionable button should inform the delegate to retry")

        delegate?.capturedAction = nil
        controller.performAction()
        XCTAssertNil(delegate?.capturedAction,
                     "Tapping the actionable button again should not inform the delegate of anything")
    }

    func testOutOfBandActions() {
        controller.delegate = delegate

        controller.performAction()
        XCTAssertNil(delegate?.capturedAction, "Should not perform an action when in a state that doesn't allow actions")

        controller.configure(for: .actionable(action: .retry))
        controller.configure(for: .resolving)
        controller.performAction()
        XCTAssertNil(delegate?.capturedAction, "Should not perform an action when in a state that doesn't allow actions")

        controller.configure(for: .actionable(action: .retry))
        controller.configure(for: .resolved(placemark: SamplePlacemarks.denver))
        controller.performAction()
        XCTAssertNil(delegate?.capturedAction, "Should not perform an action when in a state that doesn't allow actions")
    }

    private func showSubviews() {
        controller.mainStack.arrangedSubviews.forEach { $0.isHidden = false }
    }
}

class FakeLocationResolutionDelegate: LocationResolutionDisplayDelegate {
    var capturedAction: LocationResolutionDisplayState.Action?

    func userRequestedResolutionAction(_ action: LocationResolutionDisplayState.Action) {
        capturedAction = action
    }
}
