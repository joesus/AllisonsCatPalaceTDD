//
//  PetFinderSearchControllerTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 11/5/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetFinderSearchControllerTests: XCTestCase {

    var searchController: PetFinderSearchController!
    var indices: [Int]!

    override func setUp() {
        super.setUp()

        searchController = PetFinderSearchController(
            with: SampleSearchParameters.minimalSearchOptions,
            pageSize: 3,
            finderProxy: FakeRegistry.self
        ) { indices in
            self.indices = indices
        }
    }

    override func tearDown() {
        FakeRegistry.reset()

        super.tearDown()
    }

    func testHasNoRetrievedResultsByDefault() {
        XCTAssertTrue(searchController.results.isEmpty,
                      "Context should have no results by default")
    }

    func testResultsNotKnownToBeExhaustedByDefault() {
        XCTAssertFalse(searchController.resultsKnownToBeExhausted,
                       "Context should assume more available results by default")
    }

    func testInitiatingSearch() {
        searchController.getMoreResults()

        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 1,
                       "Getting more results should invoke a search on on the context's finder proxy")
        XCTAssertEqual(
            FakeRegistry.capturedSearchParameters?.zipCode,
            SampleSearchParameters.minimalSearchOptions.zipCode,
            "Search parameters should be passed to the finder proxy"
        )
        XCTAssertEqual(
            FakeRegistry.capturedPaginationCursor,
            PaginationCursor(size: 3),
            "An initial pagination cursor should be passed to the finder proxy"
        )
    }

    func testGettingFullPageOfResults() {
        let newCats = Array(cats.prefix(3))
        searchController.getMoreResults()

        FakeRegistry.invokeCompletionHandler(with: newCats)

        zip(searchController.results, newCats).forEach {
            guard $0.0 === $0.1 else {
                return XCTFail("Context animals should match new cats")
            }
        }
        XCTAssertEqual(indices, [0, 1, 2],
                       "Context should provide indices in it's callback")
        XCTAssertFalse(searchController.resultsKnownToBeExhausted,
                       "Context should not make assumptions about future results when a full page is returned")
    }

    func testEmptyPageOfResultsDoesNotReturnResultIndices() {
        searchController.getMoreResults()

        FakeRegistry.invokeCompletionHandler(with: [])

        XCTAssertEqual(indices, [],
                       "An empty page of results should not return any indices in it's callback")
    }

    func testEmptyPageOfResultsEndsSearch() {
        searchController.getMoreResults()

        FakeRegistry.invokeCompletionHandler(with: [])

        XCTAssertTrue(searchController.resultsKnownToBeExhausted,
                      "An empty page of results should mark future searches inadvisable")
    }

    func testPartialPageOfResultsEndsSearch() {
        searchController.getMoreResults()

        // the page count is 3 so invoking with a single cat represents a partial result set
        FakeRegistry.invokeCompletionHandler(with: [SampleCat])

        XCTAssertTrue(searchController.resultsKnownToBeExhausted,
                      "A partial page of results should mark future searches inadvisable")
    }

    func testSubsequentPage() {
        // increments cursor and call count and appends results
        var newCats = Array(cats.prefix(3))
        searchController.getMoreResults()
        FakeRegistry.invokeCompletionHandler(with: newCats)

        newCats = Array(cats[3 ..< 6])
        searchController.getMoreResults()
        FakeRegistry.invokeCompletionHandler(with: newCats)

        XCTAssertEqual(
            FakeRegistry.capturedPaginationCursor,
            PaginationCursor(size: 3, index: 1),
            "An incremented pagination cursor should be passed to the finder proxy on subsequent searches"
        )

        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 2,
                       "Subsequent attempts to get more results should hit the proxy if the search is not ended")

        zip(searchController.results, cats.prefix(6)).forEach { actual, expected in
            guard actual === expected else {
                return XCTFail("Subsequent searches should append results to previous search results")
            }
        }
    }

    func testSubsequentPageWhenSearchIsEnded() {
        // does not increment cursor or call count
        searchController.getMoreResults()
        FakeRegistry.invokeCompletionHandler(with: [])

        searchController.getMoreResults()

        XCTAssertEqual(
            FakeRegistry.capturedPaginationCursor,
            PaginationCursor(size: 3, index: 0),
            "Attempting to get more results when search is ended should not increment pagination cursor"
        )

        XCTAssertEqual(FakeRegistry.findAnimalsCallCount, 1,
                       "Subsequent attempts to get more results should not hit the proxy if the search is ended")
    }
}

extension PaginationCursor: Equatable {
    public static func == (lhs: PaginationCursor, rhs: PaginationCursor) -> Bool {
        return lhs.index == rhs.index &&
            lhs.size == rhs.size
    }
}
