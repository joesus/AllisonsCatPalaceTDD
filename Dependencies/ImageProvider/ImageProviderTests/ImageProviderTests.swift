//
//  ImageProviderTests.swift
//  ImageProvider
//
//  Created by Joesus on 2/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import ImageProvider
import XCTest

class ImageProviderTests: XCTestCase {

    var receivedImage: UIImage?
    let url = URL(string: "https://example.com/foo.jpg")!
    static let imageData = UIImagePNGRepresentation(
        UIImage(
            named: "Cat.png",
            in: Bundle(for: ImageProviderTests.self),
            compatibleWith: nil
        )!
    )
    var session: FakeSession!

    override func setUp() {
        super.setUp()

        session = FakeSession()
        ImageProvider.session = session
        reset()
    }

    func reset() {
        ImageProvider.cache.removeAllCachedResponses()
        ImageProvider.currentRequestUrls.removeAll()
        ImageProvider.knownMissingImageUrls.removeAll()

        let predicate = NSPredicate { _, _ in
            ImageProvider.cache.currentMemoryUsage == 0
        }
        expectation(for: predicate, evaluatedWith: self, handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testHasACache() {
        XCTAssertEqual(ImageProvider.cache, URLCache.shared, "Image provider should use the shared URLCache")
    }

    func testUncachedImagesAreFetched() {
        ImageProvider.getImage(for: url) { _ in }

        // tests task is created
        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when uncached images are fetched")
        }

        // with the correct url
        XCTAssertEqual(task.capturedUrlRequest.url,
                       url,
                       "Data task should be created with the image url")

        // and gets started
        XCTAssert(task.resumeWasCalled,
                  "Data task should be started when uncached images are fetched")
    }

    func testHandlesNetworkFailure() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        task.completionHandler(nil, nil, fakeNetworkError)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a network error occurs")
    }

    func testHandlesServerFailure() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        task.completionHandler(nil, response404, nil)
        XCTAssertNil(receivedImage,
                     "No image should be passed to the completion handler when a server error occurs")
    }

    // nil data
    func testHandlesMissingDataWithValidResponse() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        task.completionHandler(nil, response200(url: url), nil)
        XCTAssertNil(receivedImage,
                     "No image should be created when data is missing")
    }

    func testHandlesBadDataWithValidResponse() {
        let badImageData = Data(bytes: [0x1])

        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        task.completionHandler(badImageData, response200(url: url), nil)
        XCTAssertNil(receivedImage,
                     "Bad data should not create an image")
    }

    func testImageForUrlReturnsCachedImage() {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        ImageProvider.cache.storeCachedResponse(
            CachedURLResponse(response: response, data: ImageProviderTests.imageData!),
            for: URLRequest(url: url)
        )

        XCTAssertEqual(UIImagePNGRepresentation(ImageProvider.imageForUrl(url)!), ImageProviderTests.imageData,
                       "imageForUrl should return an image if there is a cached image")
    }

    func testImageForUrlReturnsNoImageIfNoCachedImage() {
        XCTAssertNil(ImageProvider.imageForUrl(url),
                     "imageForUrl should return nil when no cached images")
    }

    func testFetchedImagesAreStoredToCache() {
        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
        }

        let predicate = NSPredicate { _ in
            guard let task = self.session.currentDataTask as? FakeDataTask else {
                return false
            }

            return ImageProvider.cache.cachedResponse(for: task.capturedUrlRequest) != nil
        }

        expectation(for: predicate, evaluatedWith: [:], handler: nil)

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }
        task.completionHandler(ImageProviderTests.imageData, response200(url: url), nil)

        waitForExpectations(timeout: 3, handler: nil)

        let response = ImageProvider.cache.cachedResponse(for: task.capturedUrlRequest)

        XCTAssertEqual(UIImagePNGRepresentation(receivedImage!), ImageProviderTests.imageData,
                       "Received image should be equal to the image")
        XCTAssertEqual(response?.data,
                       ImageProviderTests.imageData,
                       "Cached request data should equal the image data")
    }

    func testCachedImagesDoNotFetchImages() {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)

        let imageReceivedExpectation = expectation(description: "image received")

        ImageProvider.cache.storeCachedResponse(
            CachedURLResponse(response: response, data: ImageProviderTests.imageData!),
            for: URLRequest(url: url)
        )

        ImageProvider.getImage(for: url) { potentialImage in
            self.receivedImage = potentialImage
            imageReceivedExpectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)

        XCTAssertNil(session.currentDataTask,
                     "No data task should be created for a cached request")
        XCTAssertEqual(UIImagePNGRepresentation(receivedImage!), ImageProviderTests.imageData,
                       "Received image should be from the cache")
    }

    func test404DoesNotRetry() {
        // makes sure completion handler is called even if task is not started
        var firstCompletionHandlerCalled = false
        ImageProvider.getImage(for: url) { _ in
            firstCompletionHandlerCalled = true
        }

        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        task.completionHandler(nil, response404, nil)

        XCTAssertTrue(firstCompletionHandlerCalled,
                      "Should call completion handler with 404")

        session.currentDataTask = nil

        var secondCompletionHandlerCalled = false
        ImageProvider.getImage(for: url) { _ in
            secondCompletionHandlerCalled = true
        }

        XCTAssertNil(session.currentDataTask,
                     "Should not retry request for a known missing image aka: 404")
        XCTAssertTrue(secondCompletionHandlerCalled,
                      "Should call completion handler even when new task is not started")
    }

    func testDuplicateRequestsAreIgnored() {
        ImageProvider.getImage(for: url) { _ in }

        // capture first request's handler
        guard let task = session.currentDataTask as? FakeDataTask else {
            return XCTFail("Data task should be created when fetching images")
        }

        // nil out the task
        session.currentDataTask = nil

        // start an identical request
        ImageProvider.getImage(for: url) { _ in }

        // make sure another request was not started
        XCTAssertNil(session.currentDataTask,
                     "Should not duplicate an in-flight image request")

        // calls the first request's handler
        task.completionHandler(nil, nil, nil)

        // now calling a third time can start a new request
        ImageProvider.getImage(for: url) { _ in }

        // the new request starts a task
        XCTAssertNotNil(session.currentDataTask,
                        "Should start a new task if no image request is in-flight")
    }
}
