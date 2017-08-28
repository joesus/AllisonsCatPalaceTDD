//
//  AnimalCardViewTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/27/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class AnimalCardViewTests: XCTestCase {
    
    var animalCardView: AnimalCardView!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: AnimalCardView.self)
        guard let view = bundle.loadNibNamed("AnimalCardView", owner: AnimalCardView().self)?.first as? AnimalCardView else {
            return XCTFail("Should be able to instantiate AnimalCardView from nib")
        }

        animalCardView = view
    }

    func testHasImageView() {
        XCTAssertNotNil(animalCardView.imageView,
                        "Animal card view should have an image view")
    }

    func testHasNameLabel() {
        XCTAssertNotNil(animalCardView.nameLabel,
                        "Animal card view should have a name label")
    }

    func testConfiguring() {
        XCTAssertNil(animalCardView.imageView.image,
                     "Image view should have no image by default")
        XCTAssertEqual(animalCardView.nameLabel.text, "Name",
                     "Name label should have default text from storyboard")

        animalCardView.configure(with: SampleCat, image: #imageLiteral(resourceName: "catOutline"))

        XCTAssertEqual(animalCardView.imageView.image, #imageLiteral(resourceName: "catOutline"),
                       "Configuring with image should set correct image")
        XCTAssertEqual(animalCardView.nameLabel.text, "SampleCat",
                       "Configuring with animal should set animal name")
    }
}
