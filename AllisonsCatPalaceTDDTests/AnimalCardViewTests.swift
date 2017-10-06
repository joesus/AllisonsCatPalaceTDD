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

        URLSession.shared.lastResumedDataTask = nil
        URLSession.shared.lastCreatedDataTask = nil

        URLSessionDataTask.beginSpyingOnResume()
        URLSession.beginSpyingOnDataTaskCreation()
        ImageProvider.reset()

        setupComponents()
    }

    override func tearDown() {
        URLSessionDataTask.endSpyingOnResume()
        URLSession.endSpyingOnDataTaskCreation()
        ImageProvider.reset()

        super.tearDown()
    }

    func testHasImageView() {
        XCTAssertNotNil(animalCardView.imageView,
                        "Animal card view should have an image view")
        XCTAssertEqual(animalCardView.imageView.image, #imageLiteral(resourceName: "catOutline"),
                       "Image view should have a default image")
    }

    func testHasNameLabel() {
        XCTAssertNotNil(animalCardView.nameLabel,
                        "Animal card view should have a name label")
        XCTAssertEqual(animalCardView.nameLabel.text, "Name",
                       "Name label should have default text from storyboard")
    }

    func testUsesDefaultImageWhenConfiguringWithNoImage() {
        animalCardView.configure(with: SampleCat)

        XCTAssertEqual(animalCardView.imageView.image, #imageLiteral(resourceName: "catOutline"),
            "Image view should use a default image when configured with no image")
    }

    func testConfiguringUsesCacheIfAvailable() {
        let cat = cats.first!
        let url = cat.imageLocations.medium.first!
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))

        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)

        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: url))

        animalCardView.configure(with: cat)

        let predicate = NSPredicate { _,_ in
            guard let image = self.animalCardView.imageView.image else {
                return false
            }

            return UIImagePNGRepresentation(image) == UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        waitForExpectations(timeout: 3, handler: nil)

        XCTAssertNil(URLSession.shared.lastCreatedDataTask, // can assume it's from cache because of no data task
            "No data task should be created for a cached request")
    }

    func testConfiguringFetchesFirstMediumImageIfNothingCached() {
        let imageLocations = SampleImageLocations.smallMediumLarge
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/medium-cat.png",
                       "Configuring should fetch the first medium image if nothing is cached")
    }

    func testConfiguringFetchesFirstSmallImageIfNoMediumImageAvailable() {
        let imageLocations = SampleImageLocations.smallAndLargeOnly
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/catSmall.png",
                       "Configuring should fetch the first small image if no medium image is available")
    }

    func testConfiguringFetchesFirstLargeImageIfNoMediumOrSmallAvailable() {
        let imageLocations = SampleImageLocations.largeOnly
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/catLarge.png",
                       "Configuring should fetch the first large image if no medium or small images are available")
    }

    func testConfiguringUsesFetchedImageIfNoImageCachedImageAvailable() {
        let cat = cats.first!
        let url = cat.imageLocations.medium.first!
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
        animalCardView.configure(with: cat)

        let predicate = NSPredicate { _,_ in
            guard let image = self.animalCardView.imageView.image else {
                return false
            }

            return UIImagePNGRepresentation(image) == UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        URLSession.shared.capturedCompletionHandler?(imageData, response200(url: url), nil)

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testConfiguringWithAnimal() {
        animalCardView.configure(with: SampleCat)

        XCTAssertEqual(animalCardView.nameLabel.text, "SampleCat",
                       "Configuring with animal should set animal name")
    }
}

// TODO - tests to make sure it's setting images on main thread.

extension AnimalCardViewTests {
    func setupComponents() {
        let bundle = Bundle(for: AnimalCardView.self)
        guard let view = bundle.loadNibNamed("AnimalCardView", owner: nil)?.first as? AnimalCardView else {
            return XCTFail("Should be able to instantiate AnimalCardView from nib")
        }

        animalCardView = view
    }
}
