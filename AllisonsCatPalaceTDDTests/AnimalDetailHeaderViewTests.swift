//
//  AnimalDetailHeaderViewTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/13/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import TestSwagger
import TestableUIKit
import XCTest

class AnimalDetailHeaderViewTests: XCTestCase {

    var setNeedsLayoutSpy: Spy?

    override func setUp() {
        super.setUp()

        URLSession.beginSpyingOnDataTaskCreation()
    }

    override func tearDown() {
        super.tearDown()

        URLSession.endSpyingOnDataTaskCreation()
    }

    func testContainsAView() {
        let bundle = Bundle(for: AnimalDetailHeaderView.self)
        guard let _ = bundle.loadNibNamed("AnimalDetailHeaderView", owner: AnimalDetailHeaderView().self)?.first as? UIView else {
            return XCTFail("Animal detail header view did not contain a UIView")
        }
    }

    func testInitializingWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        XCTAssertFalse(AnimalDetailHeaderView(frame: frame).subviews.isEmpty,
                       "AnimalDetailHeaderView should add subviews from nib when instantiated in code")
    }

    func testIsIBDesignable() {
        let header = AnimalDetailHeaderView()
        header.subviews.forEach { $0.removeFromSuperview() }
        XCTAssertEqual(header.subviews, [],
                       "AnimalDetailHeaderView view should have all subviews removed")
        header.prepareForInterfaceBuilder()
        XCTAssertFalse(header.subviews.isEmpty,
                       "AnimalDetailHeaderView should add subviews from nib when prepared for interface builder")
    }

    func testHasImageView() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let header = AnimalDetailHeaderView(frame: frame)
        guard let _ = header.imageView else {
            return XCTFail("AnimalDetailHeaderView should contain an image view")
        }
    }

    func testSettingAnimal() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let header = AnimalDetailHeaderView(frame: frame)

        header.animal = SampleCat
        guard let headerAnimal = header.animal,
            headerAnimal === SampleCat else {
                return XCTFail("Header should know about an animal to display information about")
        }
    }


    // Test that it's called on the main queue
    func testSettingAnimalFetchesLargeImageIfAvailable() {
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        let header = AnimalDetailHeaderView(frame: frame)

        setNeedsLayoutSpy = UIView.SetNeedsLayoutSpyController.createSpy(on: header)
        setNeedsLayoutSpy?.beginSpying()

        let setNeedsLayoutCalledExpectation = NSPredicate { _, _ in
            header.setNeedsLayoutCalled
        }

        let _ = expectation(for: setNeedsLayoutCalledExpectation, evaluatedWith: self, handler: nil)

        header.animal = cats.first!

        // gets captured completion handler for image fetch
        let handler = URLSession.shared.capturedCompletionHandler

        // calls the image handler with the large image
        DispatchQueue.global(qos: .background).async {
            handler!(imageData, response200(url: cats.first!.imageLocations.large.first!), nil)
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertTrue(header.setNeedsLayoutCalledOnMainThread,
                      "Set needs layout must be called on the main thread")

        setNeedsLayoutSpy?.endSpying()
    }

}
