//
//  AnimalCardsViewControllerTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import TestableUIKit
import Koloda
import RealmSwift
import XCTest

class AnimalCardsViewControllerTests: XCTestCase {
    var controller: AnimalCardsViewController!
    var deckView: KolodaView!
    var dataSource: KolodaViewDataSource!
    var realm: Realm!

    override func setUp() {
        super.setUp()

        MockRegistry.reset() //Clears call counts and stored animals between tests
        ImageProvider.reset()

        realm = realmForTest(withName: name!)
        reset(realm)

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: AnimalCardsViewController.self)).instantiateViewController(withIdentifier: "AnimalCardsViewController") as? AnimalCardsViewController else {
            return XCTFail("Should be able to instantiate animal cards view controller from main storyboard")
        }
        controller = vc
        controller.registry = MockRegistry.self
        controller.loadViewIfNeeded()

        deckView = controller.deckView
        dataSource = deckView.dataSource

        MockRegistry.reset() //Clears call counts and stored animals between tests
        ImageProvider.reset()
    }

    func testHasNoAnimalsByDefault() {
        XCTAssert(controller.animals.isEmpty, "AnimalCardsViewController should have no animals by default")
    }

    func testViewDidLoadCallsSuperViewDidLoad() {
        UITableViewController.ViewDidLoadSpyController.createSpy(on: controller)!.spy {
            controller.viewDidLoad()
            XCTAssert(controller.superclassViewDidLoadCalled, "ViewDidLoad should call viewDidLoad on UIViewController")
        }
    }

    func testRequestsAnimalsOnViewDidLoad() {
        controller.viewDidLoad()
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 1,
                       "Registry should be called when view loads")
    }

    func testResetsRegistryOffsetOnViewDidLoad() {
        MockRegistry.offset = 20

        controller.viewDidLoad()

        XCTAssertEqual(MockRegistry.offset, 0,
                       "Controller should reset registry offset on viewDidLoad")
    }

    func testHasDeckView() {
        XCTAssertNotNil(controller.deckView,
                        "Controller should have a deck view to display cards")
    }

    func testDeckViewDragSpeed() {
        XCTAssertEqual(dataSource.kolodaSpeedThatCardShouldDrag(deckView), .default,
                       "Deck view should use default drag speed")
    }

    func testDeckViewNumberOfCards() {
        controller.animals = cats
        XCTAssertEqual(dataSource.kolodaNumberOfCards(deckView), cats.count,
                       "Deck view should have a card for each animal on the controller")
    }

    func testDeckViewForCard() {
        controller.animals = cats
        guard let animalCardView = dataSource.koloda(deckView, viewForCardAt: 0) as? AnimalCardView else {
            return XCTFail("Deck view should provide animal card views")
        }

        XCTAssertTrue(animalCardView.layer.masksToBounds,
                      "Layer should mask to bounds")
        XCTAssertTrue(animalCardView.layer.cornerRadius > 0,
                      "Layer should have rounded cornders")
        XCTAssertEqual(animalCardView.layer.borderWidth, 1.0,
                       "Layer should have a border with correct width")
        XCTAssertEqual(animalCardView.layer.borderColor, UIColor.black.cgColor,
                       "Layer should have correct border color")
    }

    func testIsDeckViewDataSourceAndDelegate() {
        XCTAssertTrue(deckView.dataSource === controller,
                      "Controller is the data source for the deck view")
        XCTAssertTrue(deckView.delegate === controller,
                      "Controller is the delegate for the deck view")
    }

    func testDeckViewSwipeThreshold() {
        XCTAssertEqual(deckView.delegate?.kolodaSwipeThresholdRatioMargin(deckView), 0.35,
                       "Deck view should have a comfortable swipe threshold")
    }

    func testDeckViewForOverlay() {
        controller.animals = cats

        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        deckView.frame = frame

        guard let overlay = dataSource.koloda(deckView, viewForCardOverlayAt: 0) as? SwipeOverlayView else {
            return XCTFail("Overlay for cards should be a swipe overlay view")
        }

        XCTAssertTrue(overlay.layer.masksToBounds,
                      "Overlay layer should mask to bounds")
        XCTAssertEqual(overlay.layer.cornerRadius, frame.width / 10,
                       "Overlay layer should have a rounded frame")
    }

    func testDeckViewDoesNotFetchMoreAnimalsWhenMoreThanTenRemaining() {
        controller.registry = MockRegistry.self
        controller.animals = Array(repeating: SampleCat, count: 20)

        _ = dataSource.koloda(deckView, viewForCardAt: 0)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 0,
                       "Should not call registry when more than 10 cards remaining")
    }

    func testDeckViewDoesNotFetchMoreAnimalsWhenFewerThanTenRemaining() {
        controller.registry = MockRegistry.self
        controller.animals = Array(repeating: SampleCat, count: 9)

        _ = dataSource.koloda(deckView, viewForCardAt: 0)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 0,
                       "Should not call registry when fewer than 10 cards remaining")
    }

    func testDeckViewFetchesMoreAnimalsWhenTenCardsRemaining() {
        controller.registry = MockRegistry.self
        MockRegistry.animals = Array(repeating: SampleCat, count: 50)
        controller.animals = Array(repeating: SampleCat, count: 50)

        _ = dataSource.koloda(deckView, viewForCardAt: 40)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 1,
                       "Should call registry when exactly 10 cards remaining")
        XCTAssertEqual(controller.animals.count, 100,
                       "Retrieving additional animals should add new animals to the remaining, existing animals")

        _ = dataSource.koloda(deckView, viewForCardAt: 90)

        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 2,
                       "Should call registry when exactly 10 cards remaining")
        XCTAssertEqual(controller.animals.count, 150,
                       "Retrieving additional animals should add new animals to the existing animals")
    }

    func testLoadingIndicatorWithNoCats() {
        // This passes because of the delay on the fetching callback, if that changes this may begin to fail
        MockRegistry.animals = Array(repeating: SampleCat, count: 50)
        XCTAssertTrue(controller.activityIndicator.isAnimating,
                      "Activity indicator should be animating when there are no animal cards to display")

        let predicate = NSPredicate { _,_ in
            !self.controller.activityIndicator.isAnimating
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)


        controller.viewDidLoad()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLoadingCatsPrefetchesMediumSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedMedium.png")!
        let imageLocations = AnimalImageLocations(small: [], medium: [urlToPreload], large: [])
        cats[10].imageLocations = imageLocations

        // loads cats from the mock registry - waiting for the tenth card to be loaded since it will indicate that card images are being loaded before they are being displayed
        MockRegistry.animals = cats
        controller.viewDidLoad()

        let predicate = NSPredicate { _,_ in
            ImageProvider.cache.cachedResponse(for: URLRequest(url: urlToPreload)) != nil
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLoadingCatsPrefetchesSmallSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedSmall.png")!
        let imageLocations = AnimalImageLocations(small: [urlToPreload], medium: [], large: [])
        cats[10].imageLocations = imageLocations

        MockRegistry.animals = cats
        controller.viewDidLoad()

        let predicate = NSPredicate { _,_ in
            ImageProvider.cache.cachedResponse(for: URLRequest(url: urlToPreload)) != nil
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testLoadingCatsPrefetchesLargeSizedImages() {
        let urlToPreload = URL(string: "https://www.example.com/preloadedLarge.png")!
        let imageLocations = AnimalImageLocations(small: [], medium: [], large: [urlToPreload])
        cats[10].imageLocations = imageLocations

        MockRegistry.animals = cats
        controller.viewDidLoad()

        let predicate = NSPredicate { _,_ in
            ImageProvider.cache.cachedResponse(for: URLRequest(url: urlToPreload)) != nil
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSwipingRightSavesSingleAnimalToFavorites() {
        var savedAnimals: [Animal]

        MockRegistry.animals = cats
        controller.viewDidLoad()

        savedAnimals = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

        XCTAssertTrue(savedAnimals.isEmpty,
                      "There should be no saved animals without swiping")

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)

        savedAnimals = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

        XCTAssertFalse(savedAnimals.isEmpty,
                       "Swiping right should save an animal")
    }

    func testSwipingRightMultipleTimes() {
        MockRegistry.animals = cats
        controller.viewDidLoad()
        
        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)
        deckView.delegate?.koloda(deckView, didSwipeCardAt: 1, in: .right)

        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

        XCTAssertFalse(savedAnimals.isEmpty,
                       "Swiping right should save an animal")
        XCTAssertEqual(savedAnimals.count, 2,
                      "Swiping right twice should save two animals")
    }

    func testSwipingRightMultipleTimesSameCard() {
        MockRegistry.animals = cats
        controller.viewDidLoad()

        let predicate = NSPredicate { _, _ in
            self.controller.animals.count > 0
        }

        expectation(for: predicate, evaluatedWith: self, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)
        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .right)

        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

        XCTAssertFalse(savedAnimals.isEmpty,
                       "Swiping right should save an animal")
        XCTAssertEqual(savedAnimals.count, 1,
                       "Swiping right twice on the same animal should only save one animal")
    }

    func testSwipingLeftDoesNotSaveToFavorites() {
        MockRegistry.animals = cats
        controller.viewDidLoad()

        deckView.delegate?.koloda(deckView, didSwipeCardAt: 0, in: .left)

        let savedAnimals: [Animal] = realm.objects(AnimalObject.self).flatMap { animalObject in
            return Animal(managedObject: animalObject)
        }

        XCTAssertTrue(savedAnimals.isEmpty,
                      "Swiping left should not save animal")
    }

    func testFavoritesButton() {
        XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Favorites",
                       "Favorites button exists and has correct title")
    }

    func testFavoritesSegue() {
        guard let navController = UIStoryboard(name: "Main", bundle: Bundle(for: AnimalCardsViewController.self)).instantiateInitialViewController() as? UINavigationController else {
            return XCTFail("Main storyboard should have a navigation controller")
        }

        replaceRootViewController(with: navController) // add it to the window
        navController.addChildViewController(controller) // make controller the top view controller

        let predicate = NSPredicate { _, _ in
            navController.topViewController is FavoritesListController
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        UIViewController.PerformSegueSpyController.createSpy(on: controller)!.spy {
            controller.performSegue(withIdentifier: "showFavoritesListController", sender: controller.navigationItem.rightBarButtonItem)

            waitForExpectations(timeout: 2, handler: nil)

            XCTAssertTrue(controller.performSegueCalled,
                          "Perform segue should be called on controller")
            XCTAssertEqual(controller.performSegueIdentifier, "showFavoritesListController",
                           "Segue identifier should identify the destination of the segue")
        }
    }

    // TODO - test for clicking card to get to detail view
    func testPrepareForSegue() {
        // TODO - for clicking on card passing known information
    }
}

fileprivate class MockRegistry: AnimalFetching {
    static var animals = [Animal]()
    static var fetchAllAnimalsCallCount = 0
    static var offset: Int = 0

    static func fetchAllAnimals(completion: @escaping ([Animal]) -> Void) {
        fetchAllAnimalsCallCount += 1
        completion(animals)
    }
    static func fetchAnimal(withIdentifier identifier: Int, completion: @escaping (Animal?) -> Void) {
        completion(animals.first)
    }

    static func reset() {
        animals = [Animal]()
        fetchAllAnimalsCallCount = 0
    }
}
