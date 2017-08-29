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

    // TODO: - figure out how to test that the registry was called. 
    // Maybe refactor to make instance methods on the registry
    //    func testRequestsAnimalsOnViewDidLoad() { }

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

    func testKolodaViewFetchesMoreAnimalsWhenNearingEndOfCards() {
        // 
    }

}
