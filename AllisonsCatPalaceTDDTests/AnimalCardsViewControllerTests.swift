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
import XCTest

class AnimalCardsViewControllerTests: XCTestCase {
    var controller: AnimalCardsViewController!
    var kolodaView: KolodaView!
    var dataSource: KolodaViewDataSource!

    override func setUp() {
        super.setUp()

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: AnimalCardsViewController.self)).instantiateViewController(withIdentifier: "AnimalCardsViewController") as? AnimalCardsViewController else {
            return XCTFail("Should be able to instantiate animal cards view controller from main storyboard")
        }
        controller = vc
        controller.loadViewIfNeeded()

        kolodaView = controller.kolodaView
        dataSource = kolodaView.dataSource

        MockRegistry.reset() //Clears call counts and stored animals between tests
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
        controller.registry = MockRegistry.self
        controller.viewDidLoad()
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 1,
                       "Registry should be called when view loads")
    }

    func testHasKolodaView() {
        XCTAssertNotNil(controller.kolodaView,
                        "Controller should have a koloda view to display cards")
    }

    func testKolodaViewDragSpeed() {
        XCTAssertEqual(dataSource.kolodaSpeedThatCardShouldDrag(kolodaView), .default,
                       "Koloda view should use default drag speed")
    }

    func testKolodaViewNumberOfCards() {
        controller.animals = cats
        XCTAssertEqual(dataSource.kolodaNumberOfCards(kolodaView), cats.count,
                       "Koloda view should have a card for each animal on the controller")
    }

    func testKolodaViewForCard() {
        controller.animals = cats
        guard let animalCardView = dataSource.koloda(kolodaView, viewForCardAt: 0) as? AnimalCardView else {
            return XCTFail("Koloda view should provide animal card views")
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

    func testIsKolodaViewDataSourceAndDelegate() {
        XCTAssertTrue(kolodaView.dataSource === controller,
                      "Controller is the data source for the koloda view")
        XCTAssertTrue(kolodaView.delegate === controller,
                      "Controller is the delegate for the koloda view")
    }

    func testKolodaViewSwipeThreshold() {
        XCTAssertEqual(kolodaView.delegate?.kolodaSwipeThresholdRatioMargin(kolodaView), CGFloat(0.35),
                       "Koloda view should have a comfortable swipe threshold")
    }

    func testKolodaViewForOverlay() {
        controller.animals = cats
        guard let overlay = dataSource.koloda(kolodaView, viewForCardOverlayAt: 0) as? SwipeOverlayView else {
            return XCTFail("Overlay for cards should be a swipe overlay view")
        }

        XCTAssertTrue(overlay.layer.masksToBounds,
                      "Overlay layer should mask to bounds")
        XCTAssertEqual(overlay.layer.cornerRadius, kolodaView.frame.width / 10,
                       "Overlay layer should have a rounded frame")
    }

    func testKolodaViewDoesNotFetchMoreAnimalsWhenMoreThanTenRemaining() {
        controller.registry = MockRegistry.self
        controller.animals = Array(repeating: SampleCat, count: 20)

        _ = dataSource.koloda(kolodaView, viewForCardAt: 0)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 0,
                       "Should not call registry when more than 10 cards remaining")
    }

    func testKolodaViewDoesNotFetchMoreAnimalsWhenFewerThanTenRemaining() {
        controller.registry = MockRegistry.self
        controller.animals = Array(repeating: SampleCat, count: 9)

        _ = dataSource.koloda(kolodaView, viewForCardAt: 0)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 0,
                       "Should not call registry when fewer than 10 cards remaining")
    }

    func testKolodaViewFetchesMoreAnimalsWhenTenCardsRemaining() {
        controller.registry = MockRegistry.self
        MockRegistry.animals = Array(repeating: SampleCat, count: 50)
        controller.animals = Array(repeating: SampleCat, count: 50)

        _ = dataSource.koloda(kolodaView, viewForCardAt: 40)
        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 1,
                       "Should call registry when exactly 10 cards remaining")
        XCTAssertEqual(controller.animals.count, 100,
                       "Retrieving additional animals should add new animals to the remaining, existing animals")

        _ = dataSource.koloda(kolodaView, viewForCardAt: 90)

        XCTAssertEqual(MockRegistry.fetchAllAnimalsCallCount, 2,
                       "Should call registry when exactly 10 cards remaining")
        XCTAssertEqual(controller.animals.count, 150,
                       "Retrieving additional animals should add new animals to the existing animals")
    }

    func testLoadingIndicatorWithNoCats() {
        controller.registry = MockRegistry.self
        MockRegistry.animals = Array(repeating: SampleCat, count: 50)
        XCTAssertTrue(controller.activityIndicator.isAnimating,
                      "Activity indicator should be animating when there are no animal cards to display")

        let predicate = NSPredicate { _,_ in
            !self.controller.activityIndicator.isAnimating
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)

        controller.viewDidLoad()
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
