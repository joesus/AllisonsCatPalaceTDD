//
//  AnimalCardsViewControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import ImageProviding
import Koloda
import RealmSwift
import TestableUIKit
import XCTest

class AnimalCardsViewControllerTests: XCTestCase {
    var scene: AnimalCardsViewController!
    var deckView: KolodaView!
    var dataSource: KolodaViewDataSource!
    var realm: Realm!

    override func setUp() {
        super.setUp()

        FakeRegistry.reset() //Clears call counts and stored animals between tests
        Dependencies.imageProvider = FakeImageProvider.self
        realm = realmForTest(withName: name!)

        resetRealm(realm)

        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle(for: AnimalCardsViewController.self)
        )

        scene = storyboard.instantiateViewController(withIdentifier: "SearchResultsScene")
            as? AnimalCardsViewController

        scene.loadViewIfNeeded()

        scene.imageProvider = FakeImageProvider.self
        scene.searchCriteria = SampleSearchParameters.minimalSearchOptions
        deckView = scene.deckView
        dataSource = deckView.dataSource
    }

    override func tearDown() {
        FakeRegistry.reset()

        super.tearDown()
    }

    func testHasRegistry() {
        XCTAssertTrue(scene.registry == PetFinderAnimalRegistry.self,
                      "Scene should have a registry that defaults to the PetFinder registry")
    }

    func testHasSearchCriteria() {
        XCTAssertNotNil(scene.searchCriteria, "Scene should have the search criteria")
    }

    // MARK: - View Lifecycle Tests

    func testViewDidLoadCallsSuperViewDidLoad() {
        UIViewController.ViewDidLoadSpyController.createSpy(on: scene)!.spy {
            scene.viewDidLoad()
            XCTAssertTrue(scene.superclassViewDidLoadCalled,
                          "Scene should call its superclass implementations of `viewDidLoad`")
        }
    }

    func testViewDidAppearCallsSuperViewDidAppear() {
        UIViewController.ViewDidAppearSpyController.createSpy(on: scene)!.spy {
            scene.viewDidAppear(false)
            XCTAssertTrue(scene.superclassViewDidAppearCalled,
                          "Scene should call its superclass implementations of `viewDidAppear`")
        }
    }

    func testInitiatesSearchOnInitialAppearance() {
        scene.registry = FakeRegistry.self

        scene.viewDidAppear(false)

        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 1,
                       "Registry should be called when view appears")
        XCTAssertEqual(
            FakeRegistry.capturedSearchParameters?.zipCode,
            SampleSearchParameters.zipCode,
            "Correct search criteria should be passed to the registry"
        )
    }

    func testSubsequentAppearanceDoesNotInvokeSearch() {
        scene.registry = FakeRegistry.self

        scene.viewDidAppear(false)
        scene.viewDidAppear(false)

        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 1,
                       "Registry should not be called on subsequent appearances")
    }

    // MARK: - View Property Tests

    func testHasDeckView() {
        scene.viewDidLoad()

        XCTAssertNotNil(scene.deckView,
                        "Scene should have a deck view to display cards")
        XCTAssertTrue(deckView.dataSource === scene,
                      "Scene is the data source for the deck view")
        XCTAssertTrue(deckView.delegate === scene,
                      "Scene is the delegate for the deck view")
    }

    func testHasActivityIndicator() {
        XCTAssertNotNil(scene.activityIndicator,
                        "Scene should have an activity indicator")
    }

    // MARK: - Deck View Configuration

    func testDeckViewDragSpeed() {
        XCTAssertEqual(dataSource.kolodaSpeedThatCardShouldDrag(deckView), .default,
                       "Deck view should use default drag speed")
    }

    func testNumberOfCards() {
        XCTAssertEqual(dataSource.kolodaNumberOfCards(deckView), 0,
                       "Deck view should have no cards by default")

        scene.registry = FakeRegistry.self
        scene.viewDidAppear(false)

        FakeRegistry.invokeCompletionHandler(with: Array(cats.prefix(17)))

        XCTAssertEqual(dataSource.kolodaNumberOfCards(deckView), 17,
                       "Deck view should have a card for each animal in the search results")
    }

    func testCardForAnimal() {
        scene.registry = FakeRegistry.self
        scene.viewDidAppear(false)

        FakeRegistry.invokeCompletionHandler(with: [cats.first!])

        guard let animalCardView = dataSource.koloda(deckView, viewForCardAt: 0) as? AnimalCardView else {
            return XCTFail("Deck view should provide animal card views")
        }

        XCTAssertTrue(animalCardView.clipsToBounds,
                      "Should clip to bounds")
        XCTAssertEqual(animalCardView.cornerRadius, 5,
                       "Should have rounded corners")
        XCTAssertEqual(animalCardView.borderWidth, 1,
                       "Should have a border with correct width")
        XCTAssertEqual(animalCardView.borderColor, .black,
                       "Should have correct border color")
    }

    func testSwipeThreshold() {
        XCTAssertEqual(
            deckView.delegate?.kolodaSwipeThresholdRatioMargin(deckView),
            0.35,
            "Deck view should have a comfortable swipe threshold"
        )
    }

    func testCardOverlay() {
        scene.viewDidAppear(false)

        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        deckView.frame = frame

        guard let overlay = dataSource.koloda(deckView, viewForCardOverlayAt: 0) as? SwipeOverlayView else {
            return XCTFail("Overlay for cards should be a swipe overlay view")
        }

        XCTAssertTrue(overlay.clipsToBounds,
                      "Overlay should clip to bounds")
        XCTAssertEqual(overlay.cornerRadius, 5,
                       "Overlay should have rounded corners")
    }

    func testDeckViewDoesNotFetchMoreAnimalsWhenMoreThanTenRemaining() {
        FakeRegistry.findAnimalsCallCount = 0
//        controller.registry = FakeRegistry.self
//
//        controller.animals = Array(repeating: SampleCat, count: 20)
//
//        _ = dataSource.koloda(deckView, viewForCardAt: 0)
//        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 0,
//                       "Should not call registry when more than 10 cards remaining")
    }

    func testDeckViewDoesNotFetchMoreAnimalsWhenFewerThanTenRemaining() {
//        FakeRegistry.findAnimalsCallCount = 0
//        controller.registry = FakeRegistry.self
//
//        controller.animals = Array(repeating: SampleCat, count: 9)
//
//        _ = dataSource.koloda(deckView, viewForCardAt: 0)
//        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 0,
//                       "Should not call registry when fewer than 10 cards remaining")
    }

    func testDeckViewFetchesMoreAnimalsWhenTenCardsRemaining() {
//        FakeRegistry.findAnimalsCallCount = 0
//        controller.registry = FakeRegistry.self
//        FakeRegistry.stubbedAnimals = Array(repeating: SampleCat, count: 50)
//        controller.animals = Array(repeating: SampleCat, count: 50)
//
//        _ = dataSource.koloda(deckView, viewForCardAt: 40)
//        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 1,
//                       "Should call registry when exactly 10 cards remaining")
//        XCTAssertEqual(controller.animals.count, 100,
//                       "Retrieving additional animals should add new animals to the remaining, existing animals")
//
//        _ = dataSource.koloda(deckView, viewForCardAt: 90)
//
//        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 2,
//                       "Should call registry when exactly 10 cards remaining")
//        XCTAssertEqual(controller.animals.count, 150,
//                       "Retrieving additional animals should add new animals to the existing animals")
    }

    func testLoadingIndicatorWithNoCats() {
        // This passes because of the delay on the fetching callback, if that changes this may begin to fail
//        FakeRegistry.stubbedAnimals = Array(repeating: SampleCat, count: 50)
//        XCTAssertTrue(controller.activityIndicator.isAnimating,
//                      "Activity indicator should be animating when there are no animal cards to display")
//
//        let predicate = NSPredicate { _, _ in
//            !self.controller.activityIndicator.isAnimating
//        }
//        expectation(for: predicate, evaluatedWith: self, handler: nil)
//
//        waitForExpectations(timeout: 3, handler: nil)
    }

    func testHasImageProvider() {
        XCTAssertTrue(scene.imageProvider == FakeImageProvider.self as ImageProviding.Type,
                      "Scene should have a default image provider")
    }

    func testInjectionOfImageProviderToCardView() {
        scene.registry = FakeRegistry.self
        scene.viewDidAppear(false)

        FakeRegistry.invokeCompletionHandler(with: [cats.first!])

        guard let animalCardView = dataSource.koloda(deckView, viewForCardAt: 0) as? AnimalCardView else {
            return XCTFail("Deck view should provide animal card views")
        }

        guard let imageProvider = animalCardView.imageProvider else {
            return XCTFail("Card view should have an image provider")
        }

        XCTAssertTrue(imageProvider == FakeImageProvider.self,
                      "Scene should inject the image provider for each card it creates")
    }

    func testLoadingCatsPrefetchesMediumSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedMedium.png")!
        let imageLocations = AnimalImageLocations(small: [], medium: [urlToPreload], large: [])
        cats[1].imageLocations = imageLocations

        FakeRegistry.stubbedAnimals = cats
        scene.registry = FakeRegistry.self
        scene.viewDidAppear(false)

        XCTAssertEqual(FakeImageProvider.capturedURL, urlToPreload,
                       "Loading animals should attempt to load the correct URL")
//        let predicate = NSPredicate { _, _ in
//            ImageProvider.cache.cachedResponse(for: URLRequest(url: urlToPreload)) != nil
//        }
//        expectation(for: predicate, evaluatedWith: self, handler: nil)
//
//        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLoadingCatsPrefetchesSmallSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedSmall.png")!
        let imageLocations = AnimalImageLocations(small: [urlToPreload], medium: [], large: [])
        cats[10].imageLocations = imageLocations

        FakeRegistry.stubbedAnimals = cats
        scene.viewDidLoad()

        let predicate = NSPredicate { _, _ in
            Dependencies.imageProvider.image(for: urlToPreload) != nil
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testLoadingCatsPrefetchesLargeSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedLarge.png")!
        let imageLocations = AnimalImageLocations(small: [], medium: [], large: [urlToPreload])
        cats[10].imageLocations = imageLocations

        FakeRegistry.stubbedAnimals = cats
        scene.viewDidLoad()

        let predicate = NSPredicate { _, _ in
            Dependencies.imageProvider.image(for: urlToPreload) != nil
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSwipingRightSavesSingleAnimalToFavorites() {
        var savedAnimals: [Animal]

        FakeRegistry.stubbedAnimals = cats
        scene.viewDidLoad()

        savedAnimals = realm.objects(AnimalObject.self).flatMap { animalObject in
            Animal(managedObject: animalObject)
        }

        XCTAssertTrue(savedAnimals.isEmpty,
                      "There should be no saved animals without swiping")

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)

        savedAnimals = realm.objects(AnimalObject.self).flatMap { animalObject in
            Animal(managedObject: animalObject)
        }

        XCTAssertFalse(savedAnimals.isEmpty,
                       "Swiping right should save an animal")
    }

    func testSwipingRightMultipleTimes() {
        FakeRegistry.stubbedAnimals = cats
        scene.viewDidLoad()

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)
        deckView.delegate?.koloda(deckView, didSwipeCardAt: 1, in: .right)

        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
            Animal(managedObject: animalObject)
        }

        XCTAssertFalse(savedAnimals.isEmpty,
                       "Swiping right should save an animal")
        XCTAssertEqual(savedAnimals.count, 2,
                       "Swiping right twice should save two animals")
    }

    func testSwipingRightMultipleTimesSameCard() {
//        FakeRegistry.stubbedAnimals = cats
//        scene.viewDidLoad()
//
//        let predicate = NSPredicate { _, _ in
//            self.controller.animals.isEmpty
//        }
//
//        expectation(for: predicate, evaluatedWith: self, handler: nil)
//        waitForExpectations(timeout: 2, handler: nil)
//
//        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)
//        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)
//
//        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
//            Animal(managedObject: animalObject)
//        }
//
//        XCTAssertFalse(savedAnimals.isEmpty,
//                       "Swiping right should save an animal")
//        XCTAssertEqual(savedAnimals.count, 1,
//                       "Swiping right twice on the same animal should only save one animal")
    }

    func testSwipingLeftDoesNotSaveToFavorites() {
        FakeRegistry.stubbedAnimals = cats
        scene.viewDidLoad()

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .left)

        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
            Animal(managedObject: animalObject)
        }

        XCTAssertTrue(savedAnimals.isEmpty,
                      "Swiping left should not save animal")
    }

    func testFavoritesButton() {
        XCTAssertEqual(scene.navigationItem.rightBarButtonItem?.title, "Favorites",
                       "Favorites button exists and has correct title")
    }

    func testFavoritesSegue() {
        guard let navController = UIStoryboard(
            name: "Main",
            bundle: Bundle(for: AnimalCardsViewController.self)
            ).instantiateInitialViewController() as? UINavigationController
            else {
                return XCTFail("Main storyboard should have a navigation controller")
        }

        replaceRootViewController(with: navController) // add it to the window
        navController.addChildViewController(scene) // make controller the top view controller

        let predicate = NSPredicate { _, _ in
            self.scene.performSegueCalled
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        UIViewController.PerformSegueSpyController.createSpy(on: scene)!.spy {
            scene.performSegue(withIdentifier: "showFavoritesListController", sender: scene.navigationItem.rightBarButtonItem)

            waitForExpectations(timeout: 2, handler: nil)

            XCTAssertEqual(scene.performSegueIdentifier, "showFavoritesListController",
                           "Segue identifier should identify the destination of the segue")
        }
    }

    // TODO - test for clicking card to get to detail view
    func testPrepareForSegue() {
        // TODO - for clicking on card passing known information
    }
}
