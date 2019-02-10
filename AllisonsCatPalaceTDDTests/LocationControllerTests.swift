//
//  LocationControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

// swiftlint:disable file_length, line_length

@testable import AllisonsCatPalaceTDD
import AnimalData
import LocationResolver
import LocationResolving
import TestableUIKit
import TestSwagger
import XCTest

class LocationControllerTests: XCTestCase {

    var controller: LocationController!
    let fakeLocationResolver = FakeLocationResolver()
    let fakeResolutionController = FakeLocationResolutionController()

    override func setUp() {
        super.setUp()

        loadController()
        controller.locationResolver = fakeLocationResolver
        fakeLocationResolver.delegate = controller
    }

    private func loadComponents() {
        controller.loadViewIfNeeded()
    }

    private func loadController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LocationController.self))
        controller = storyboard.instantiateViewController(withIdentifier: "LocationController") as? LocationController
    }

    // MARK: Dependencies

    func testLocationResolutionDependency() {
        loadController()

        XCTAssertTrue(controller.locationResolver is LocationResolver,
                      "Controller should use correct concrete class for its location resolver")
        XCTAssertTrue(controller.locationResolver.delegate === controller,
                      "Controller should be the delegate for its location resolver")
    }

    func testApplicationDependency() {
        loadController()

        XCTAssertTrue(controller.urlOpener === UIApplication.shared,
                      "Controller should use the correct concrete instance for its application")
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

    // MARK: - Child Controllers

    func testHasLocationResolutionController() {
        loadComponents()

        guard let child = controller.children.first as? LocationResolutionController,
            child === controller.locationResolutionScene
            else {
                return XCTFail("Controller should load a location resolution controller as a child controller")
        }

        XCTAssertTrue(child.delegate === controller,
                      "Controller should be the delegate for its location resolution scene")
    }

    // MARK: - Outlets

    func testFavoritesButtonWithSavedFavorites() {
        loadComponents()

        guard let button = controller.favoritesButton,
            let target = button.target
            else {
                return XCTFail("Navigation bar should have a left bar button item with a target")
        }

        XCTAssertEqual(button.title, "Favorites",
                       "Favorites button should exist and have correct title")
        XCTAssertTrue(button.isEnabled,
                      "Favorites button should always be enabled")

        XCTAssertTrue(
            target.isKind(of: NSClassFromString("UIStoryboardShowSegueTemplate")!),
            "Favorite button target should be a show segue template"
        )

        guard let template = controller.segueTemplate(
            identifiedBy: UserInterfaceIdentifiers.SegueIdentifiers.showFavorites
            ),
            template.destinationSceneIdentifier == "FavoritesScene"
            else {
                return XCTFail("The controller should have a segue to transition to the favorites scene")
        }

        XCTAssertTrue(target === template.rawTemplate,
                      "The buttons target should be a show segue")
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

        XCTAssertTrue(controller.selectedSpecies == Species.cat,
                      "The cat species should correspond to the first segment")

        controller.speciesSelectionControl.selectedSegmentIndex = 1
        XCTAssertTrue(controller.selectedSpecies == Species.dog,
                      "The dog species should correspond to the second segment")

        controller.speciesSelectionControl.selectedSegmentIndex = 2
        XCTAssertNil(controller.selectedSpecies,
                     "The 'any' species selection should correspond to the final segment")
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
            let font = attributes[NSAttributedString.Key.font] as? UIFont
            else {
                return XCTFail("Species segmented control should have a known font")
        }

        XCTAssertEqual(font, UIFont.preferredFont(forTextStyle: .title2),
                       "Species segmented control should have a custom font for its normal state")
    }

    func testSearchButton() {
        loadComponents()

        guard let button = controller.searchButton,
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
            template.destinationSceneIdentifier == UserInterfaceIdentifiers.SceneIdentifiers.searchResults
            else {
                return XCTFail("The controller should have a segue to transition to the search results scene")
        }

        XCTAssertTrue(target === template.rawTemplate,
                      "The buttons target should be a show segue")
    }

    // MARK: - Appearing

    func testAppearingWithUnknownResolvability() {
        fakeLocationResolver.userLocationResolvability = .unknown
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)

        XCTAssertEqual(fakeLocationResolver.requestedAvailability, .whenInUse,
                       "Should request when in use authorization when appearing with an unknown resolvability")
        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state")
    }

    func testAppearingWithUnresolvability() {
        fakeLocationResolver.userLocationResolvability = .disallowed
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request authorization when appearing with a disallowed resolvability")
        XCTAssertEqual(fakeResolutionController.state, .actionable(action: .goToSettings),
                       "Should configure resolution controller with a go to settings action state")
    }

    func testAppearingWithResolvability() {
        fakeLocationResolver.userLocationResolvability = .allowed
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request authorization when appearing with an allowed resolvability")
        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state")
        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 1,
                       "Should request user location on appearance when allowed")
    }

    // MARK: - Reappearing

    func testReappearingWithUnknownResolvability() {
        fakeLocationResolver.userLocationResolvability = .unknown
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        fakeLocationResolver.requestedAvailability = nil

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertEqual(fakeLocationResolver.requestedAvailability, .whenInUse,
                       "Should request availability when reappearing with unknown resolvability")
        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state")
    }

    func testReappearingWithUnresolvability() {
        fakeLocationResolver.userLocationResolvability = .disallowed
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request availability when already disallowed")
        XCTAssertEqual(fakeResolutionController.state, .actionable(action: .goToSettings),
                       "Should configure resolution controller with a go to settings action state")
    }

    func testReappearingWithResolvability() {
        fakeLocationResolver.userLocationResolvability = .disallowed
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        fakeLocationResolver.userLocationResolvability = .allowed

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request availability more than once")
        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 1,
                       "Should request user location on reappearance when newly allowed")
        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state")
    }

    func testReappearingWithFailedResolution() {
        fakeLocationResolver.userLocationResolvability = .allowed
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        controller.didResolveLocation(
            .resolutionFailed(
                error: .unknown,
                date: Date()
            )
        )

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request availability more than once")
        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 2,
                       "Should automatically request user location on reappearance if previous request failed")

        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state on reappearance if previous request failed")
    }

    func testReappearingWithResolvedLocation() {
        fakeLocationResolver.userLocationResolvability = .allowed
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        controller.didResolveLocation(
            .resolved(
                placemark: SamplePlacemarks.denver,
                date: Date()
            )
        )
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request availability more than once")
        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 1,
                       "Should not automatically request user location on reappearance")
        XCTAssertEqual(fakeResolutionController.state, .resolved(placemark: SamplePlacemarks.denver),
                       "Should configure resolution controller with a resolved state")
    }

    func testReappearingWithExpiredResolvedLocation() {
        fakeLocationResolver.userLocationResolvability = .allowed
        loadComponents()
        controller.locationResolutionScene = fakeResolutionController
        controller.viewDidAppear(false)
        controller.viewDidDisappear(false)

        fakeLocationResolver.locationResolution = .resolved(
            placemark: SamplePlacemarks.denver,
            date: Date().addingTimeInterval(
                -1 /* subtracting time */ *
                60 /* seconds per minute */ *
                60 /* minutes per hour */
            )
        )

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertNil(fakeLocationResolver.requestedAvailability,
                     "Should not request availability more than once")
        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 2,
                       "Should automatically request user location on reappearance if the previously resolved location is stale")
        XCTAssertEqual(fakeResolutionController.state, .resolving,
                       "Should configure resolution controller with a resolving state if the previously resolved location is stale")
    }

    // MARK: - Automatic Transitions

    func testResolvingToResolutionFailure() {
        controller.locationResolutionScene = fakeResolutionController
        controller.didResolveLocation(.resolutionFailed(error: .unknown, date: Date()))

        XCTAssertEqual(fakeResolutionController.state, .actionable(action: .retry),
                       "Should configure resolution controller with an actionable retry state")
    }

    func testResolvingToResolvedLocation() {
        controller.locationResolutionScene = fakeResolutionController
        controller.didResolveLocation(.resolved(placemark: SamplePlacemarks.denver, date: Date()))

        XCTAssertEqual(fakeResolutionController.state, .resolved(placemark: SamplePlacemarks.denver),
                       "Should configure resolution controller with a resolved state")
    }

    // MARK: - Manual Transitions

    func testUserRequestsGoToSettings() {
        let fakeUrlOpener = FakeUrlOpener()
        controller.urlOpener = fakeUrlOpener
        controller.userRequestedResolutionAction(.goToSettings)

        XCTAssertEqual(fakeUrlOpener.capturedUrl, URL(string: UIApplication.openSettingsURLString),
                       "Going to settings should open the correct url")
    }

    func testUserRequestsRetry() {
        controller.userRequestedResolutionAction(.retry)

        XCTAssertEqual(fakeLocationResolver.resolveUserLocationCallCount, 1,
                       "Should request user location on user request")
    }

}
