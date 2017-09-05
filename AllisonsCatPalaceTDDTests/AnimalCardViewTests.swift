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
    }

    func testHasNameLabel() {
        XCTAssertNotNil(animalCardView.nameLabel,
                        "Animal card view should have a name label")
    }

    func testUsesDefaultImageWhenConfiguringWithNoImage() {
        XCTAssertEqual(animalCardView.imageView.image, #imageLiteral(resourceName: "catOutline"),
            "Image view should have a default image")

        animalCardView.configure(with: SampleCat)

        XCTAssertEqual(animalCardView.imageView.image, #imageLiteral(resourceName: "catOutline"),
            "Image view should use a default image when configured with no image")
    }

    func testConfiguringUsesCacheIfAvailable() {
        let url = cats[0].imageLocations.medium.first!
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))

        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)

        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: url))

        animalCardView.configure(with: cats[0])

        let predicate = NSPredicate { _,_ in
            if let image = self.animalCardView.imageView.image {
                return UIImagePNGRepresentation(image) == UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
            }
            return false
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        waitForExpectations(timeout: 3, handler: nil)

        XCTAssertNil(URLSession.shared.lastCreatedDataTask, // can assume it's from cache because of no data task
            "No data task should be created for a cached request")

        XCTAssertEqual(UIImagePNGRepresentation(animalCardView.imageView.image!), UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat")),
                       "Should set the imageView's image to the image fetched from the cache")
    }

    func testConfiguringFetchesFirstMediumImageIfNothingCached() {
        let imageLocations = AnimalImageLocations(small: [], medium: [URL(string: "https://www.google.com/catMedium.png")!, URL(string: "https://www.google.com/catMedium2.png")!], large: [])
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/catMedium.png")
    }

    func testConfiguringFetchesFirstSmallImageIfNoMediumImageAvailable() {
        let imageLocations = AnimalImageLocations(small: [URL(string: "https://www.google.com/catSmall.png")!, URL(string: "https://www.google.com/catSmall2.png")!], medium: [], large: [URL(string: "https://www.google.com/catLarge.png")!])
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/catSmall.png")
    }

    func testConfiguringFetchesFirstLargeImageIfNoMediumOrSmallAvailable() {
        let imageLocations = AnimalImageLocations(small: [], medium: [], large: [URL(string: "https://www.google.com/catLarge.png")!, URL(string: "https://www.google.com/catLarge2.png")!])
        let cat = SampleCat
        cat.imageLocations = imageLocations

        animalCardView.configure(with: cat)

        let task = URLSession.shared.lastCreatedDataTask
        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "https://www.google.com/catLarge.png")
    }

    func testConfiguringUsesFetchedImageIfNoImage() {
        let url = cats[0].imageLocations.medium.first!
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
        animalCardView.configure(with: cats[0])

        let predicate = NSPredicate { _,_ in
            if let image = self.animalCardView.imageView.image {
                return UIImagePNGRepresentation(image) == UIImagePNGRepresentation(#imageLiteral(resourceName: "testCat"))
            }
            return false
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(imageData, response200(url: url), nil)

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testConfiguringWithAnimal() {
        XCTAssertEqual(animalCardView.nameLabel.text, "Name",
                     "Name label should have default text from storyboard")

        animalCardView.configure(with: SampleCat)

        XCTAssertEqual(animalCardView.nameLabel.text, "SampleCat",
                       "Configuring with animal should set animal name")
    }
}

// TODO - tests to make sure it's setting images on main thread.

extension AnimalCardViewTests {
    func setupComponents() {
        let bundle = Bundle(for: AnimalCardView.self)
        guard let view = bundle.loadNibNamed("AnimalCardView", owner: AnimalCardView().self)?.first as? AnimalCardView else {
            return XCTFail("Should be able to instantiate AnimalCardView from nib")
        }

        animalCardView = view
    }
}
