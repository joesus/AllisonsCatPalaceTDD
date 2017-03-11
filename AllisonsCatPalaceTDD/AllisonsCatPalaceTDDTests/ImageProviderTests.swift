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

    var receivedImage: UIImage?
    let url = URL(string: "https://example.com/foo.jpg")!
    let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "catOutline"))

    override func setUp() {
        super.setUp()

        URLSession.shared.lastCreatedDataTask = nil
        URLSessionDataTask.beginSpyingOnResume()
        URLSession.beginSpyingOnDataTaskWithRequestCreation()
        ImageProvider.reset()
    }

    override func tearDown() {
        URLSessionDataTask.endSpyingOnResume()
        URLSession.endSpyingOnDataTaskWithRequestCreation()
        ImageProvider.reset()

        super.tearDown()
    }

    func testHasACache() {
        XCTAssertEqual(ImageProvider.cache, URLCache.shared, "Image provider should use the shared URLCache")
    }

    func testUncachedImagesAreFetched() {
        ImageProvider.getImage(for: url) { _ in }

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
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, nil, fakeNetworkError)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a network error occurs")
    }

    func testHandlesServerFailure() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, response404, nil)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a server error occurs")
    }

    // nil data
    func testHandlesMissingDataWithValidResponse() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, response200(url: url), nil)
        XCTAssertNil(receivedImage,
                     "No image should be created when data is missing")
    }

    func testHandlesBadDataWithValidResponse() {
        let badImageData = Data(bytes: [0x1])

        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(badImageData, response200(url: url), nil)
        XCTAssertNil(receivedImage,
                     "Bad data should not create an image")
    }

    func testFetchedImagesAreStoredToCache() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let predicate = NSPredicate { _ in
            guard let request = URLSession.shared.capturedRequest,
                ImageProvider.cache.cachedResponse(for: request) != nil else {
                return false
            }

            return true
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(imageData, response200(url: url), nil)

        waitForExpectations(timeout: 3, handler: nil)

        let response = ImageProvider.cache.cachedResponse(for: URLSession.shared.capturedRequest!)

        XCTAssertEqual(UIImagePNGRepresentation(receivedImage!), imageData,
                       "Received image should be equal to the image")
        XCTAssertEqual(response?.data, imageData,
                       "Cached request data should equal the image data")
    }

    func testCachedImagesDoNotFetchImages() {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)

        let imageReceivedExpectation = expectation(description: "image received")

        ImageProvider.cache.storeCachedResponse(CachedURLResponse(response: response, data: imageData!), for: URLRequest(url: url))

        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
            imageReceivedExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.2, handler: nil)

        XCTAssertNil(URLSession.shared.lastCreatedDataTask,
                     "No data task should be created for a cached request")
        XCTAssertEqual(UIImagePNGRepresentation(receivedImage!), imageData,
                       "Received image should be from the cache")
    }

    func test404DoesNotRetry() {
        // makes sure completion handler is called even if task is not started
        var firstCompletionHandlerCalled = false
        ImageProvider.getImage(for: url) { _ in
            firstCompletionHandlerCalled = true
        }

        let handler = URLSession.shared.capturedCompletionHandler
        handler?(nil, response404, nil)

        XCTAssertTrue(firstCompletionHandlerCalled,
                      "Should call completion handler with 404")

        URLSession.shared.lastCreatedDataTask = nil

        var secondCompletionHandlerCalled = false
        ImageProvider.getImage(for: url) { _ in
            secondCompletionHandlerCalled = true
        }

        XCTAssertNil(URLSession.shared.lastCreatedDataTask,
                     "Should not retry request for a known missing image aka: 404")
        XCTAssertTrue(secondCompletionHandlerCalled,
                      "Should call completion handler even when new task is not started")
    }

    func testDuplicateRequestsAreIgnored() {
        ImageProvider.getImage(for: url) { _ in }

        // capture first request's handler
        let handler = URLSession.shared.capturedCompletionHandler

        // nil out the task
        URLSession.shared.lastCreatedDataTask = nil

        // start an identical request
        ImageProvider.getImage(for: url) { _ in }

        // make sure another request was not started
        XCTAssertNil(URLSession.shared.lastCreatedDataTask,
                     "Should not duplicate an in-flight image request")

        // calls the first request's handler
        handler?(nil, nil, nil)

        // now calling a third time can start a new request
        ImageProvider.getImage(for: url) { _ in }

        // the new request starts a task
        XCTAssertNotNil(URLSession.shared.lastCreatedDataTask,
                        "Should start a new task if no image request is in-flight")
    }

    func testRetriesOnNetworkFailure() {

    }
}
