//
//  ImageProviderTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest
@testable import AllisonsCatPalaceTDD

class ImageProviderTests: XCTestCase {

    override func setUp() {
        super.setUp()

        URLSession.shared.lastCreatedDataTask = nil
        URLSessionDataTask.beginSpyingOnResume()
        URLSession.beginSpyingOnDataTaskWithRequestCreation()
        ImageProvider.cache.removeAllCachedResponses()
    }

    override func tearDown() {
        URLSessionDataTask.endSpyingOnResume()
        URLSession.endSpyingOnDataTaskWithRequestCreation()

        super.tearDown()
    }

    func testHasACache() {
        XCTAssertEqual(ImageProvider.cache, URLCache.shared, "Image provider should use the shared URLCache")
    }

    func testUncachedImagesAreFetched() {
        let url = URL(string: "https://example.com/foo.jpg")!

        ImageProvider.getImages(for: url) { _ in }

        // tests task is created
        guard let task = URLSession.shared.lastCreatedDataTask else {
            return XCTFail("Data task should be created when uncached images are fetched")
        }

        // with the correct url
        XCTAssertEqual(task.originalRequest?.url, url,
                       "Data task should be created with the image url")

        // and gets started
        XCTAssert(task.resumeWasCalled,
                  "Data task should be started when uncached images are fetched")

        URLSession.endSpyingOnDataTaskWithRequestCreation()
    }

    func testHandlesNetworkFailure() {
        var receivedImage: UIImage?
        let url = URL(string: "https://example.com/foo.jpg")!

        ImageProvider.getImages(for: url) { potentialImage in
            receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a network error occurs")
    }

    func testHandlesServerFailure() {
        var receivedImage: UIImage?
        let url = URL(string: "https://example.com/foo.jpg")!

        ImageProvider.getImages(for: url) { potentialImage in
            receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a server error occurs")
    }

    // nil data
    func testHandlesMissingDataWithValidResponse() {
        var receivedImage: UIImage?
        let url = URL(string: "https://example.com/foo.jpg")!

        ImageProvider.getImages(for: url) { potentialImage in
            receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, response200, nil)
        XCTAssertNil(receivedImage,
                     "No image should be created when data is missing")
    }

    func testHandlesBadDataWithValidResponse() {
        var receivedImage: UIImage?
        let url = URL(string: "https://example.com/foo.jpg")!

        let badImageData = Data(bytes: [0x1])

        ImageProvider.getImages(for: url) { potentialImage in
            receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(badImageData, response200, nil)
        XCTAssertNil(receivedImage,
                     "Bad data should not create an image")
    }

    func testFetchedImagesAreStoredToCache() {
        var receivedImage: UIImage?
        let url = URL(string: "https://example.com/foo.jpg")!
        let image = #imageLiteral(resourceName: "catOutline")
        let imageData = UIImagePNGRepresentation(image)

        ImageProvider.getImages(for: url) { potentialImage in
            receivedImage = potentialImage
        }

        let request = URLSession.shared.capturedRequest!
        let predicate = NSPredicate { _ in
            ImageProvider.cache.cachedResponse(for: request) != nil
        }
        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(imageData, response200, nil)

        waitForExpectations(timeout: 3, handler: nil)

        XCTAssertEqual(UIImagePNGRepresentation(receivedImage!), imageData, "Received image should be equal to the image")

        let response = ImageProvider.cache.cachedResponse(for: request)!

        XCTAssertEqual(response.data, imageData, "Cached request data should equal the image data")
    }

    func testCachedImagesDoNotFetchImages() {

    }
}
