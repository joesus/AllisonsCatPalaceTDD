//
//  PetfinderUrlBuilderTests.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 10/7/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class PetfinderUrlBuilderTests: XCTestCase {

    func testWellKnownValues() {
        XCTAssertEqual(PetFinderUrlBuilder.hostname, "api.petfinder.com",
                       "There should be a known hostname for building petfinder urls")
        XCTAssertEqual(PetFinderUrlBuilder.apiKey, "APIKEY",
                       "There should be a well known api key for building petfinder urls")
        XCTAssertEqual(PetFinderUrlBuilder.outputFormat, "json",
                       "There should be a well known format for building petfinder urls")
    }

    func testMethodPaths() {
        XCTAssertEqual(PetFinderUrlBuilder.MethodPaths.search, "/pet.find",
                       "Builder should know the API method for searching")
    }

    func testBaseQueryItemKeys() {
        XCTAssertEqual(
            PetFinderUrlBuilder.BaseQueryItemKeys.apiKey,
            "key",
            "Petfinder query items should have well defined keys"
        )
        XCTAssertEqual(
            PetFinderUrlBuilder.BaseQueryItemKeys.outputFormat,
            "format",
            "Petfinder query items should have well defined keys"
        )
        XCTAssertEqual(
            PetFinderUrlBuilder.BaseQueryItemKeys.recordLength,
            "output",
            "Petfinder query items should have well defined keys"
        )
    }

    func testBaseQueryItems() {
        let queryItems = PetFinderUrlBuilder.baseQueryItems
        let expectedItems: Set = [
            URLQueryItem(
                name: PetFinderUrlBuilder.BaseQueryItemKeys.apiKey,
                value: PetFinderUrlBuilder.apiKey
            ),
            URLQueryItem(
                name: PetFinderUrlBuilder.BaseQueryItemKeys.outputFormat,
                value: PetFinderUrlBuilder.outputFormat
            )
        ]

        XCTAssertEqual(queryItems, expectedItems,
                       "Base query items should contain api key and output format")
    }

    func testBuildingMinimalUrlForFindingPets() {
        let searchParameters = SampleSearchParameters.minimalSearchOptions
        let cursor = PaginationCursor(size: 20)
        let url = PetFinderUrlBuilder.buildSearchUrl(
            searchParameters: searchParameters,
            range: cursor
        )

        validateBaseUrl(url, withPath: PetFinderUrlBuilder.MethodPaths.search)

        guard let queryItems = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
            )?.queryItems
            else {
                return XCTFail("Should be able to get query items from url")
        }

        let expectedQueryItems = cursor.petFinderUrlQueryItems
            .union(searchParameters.queryItems)
            .union(PetFinderUrlBuilder.baseQueryItems)
            .union([PetFinderRecordLength.short.queryItem])

        XCTAssertEqual(
            Set(queryItems),
            expectedQueryItems,
            "Builder should use query items from minimal search parameters, pagination cursor, and base query items"
        )
    }

    func testBuildingUrlForFindingPetsWithMaximalSearchOptions() {
        let searchParameters = SampleSearchParameters.fullSearchOptions
        let cursor = PaginationCursor(size: 20)
        let url = PetFinderUrlBuilder.buildSearchUrl(
            searchParameters: searchParameters,
            range: cursor
        )

        validateBaseUrl(url, withPath: PetFinderUrlBuilder.MethodPaths.search)

        guard let queryItems = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
            )?.queryItems
            else {
                return XCTFail("Should be able to get query items from url")
        }

        let expectedQueryItems = cursor.petFinderUrlQueryItems
            .union(searchParameters.queryItems)
            .union(PetFinderUrlBuilder.baseQueryItems)
            .union([PetFinderRecordLength.short.queryItem])

        XCTAssertEqual(
            Set(queryItems),
            expectedQueryItems,
            "Builder should use query items from maximal search parameters, pagination cursor, and base query items"
        )
    }

    private func validateBaseUrl(
        _ url: URL,
        withPath path: String?,
        inFile file: StaticString = #file,
        atLine line: UInt = #line
    ) {
        XCTAssertEqual(
            url.scheme,
            "https",
            "URL should use a secure protocol",
            file: file,
            line: line
        )
        XCTAssertEqual(
            url.host,
            PetFinderUrlBuilder.hostname,
            "URL should use pet finder host name",
            file: file,
            line: line
        )
        XCTAssertNil(
            url.port,
            "URL should not override the default port",
            file: file,
            line: line
        )
        XCTAssertEqual(
            url.path,
            path ?? "",
            "URL path should be root",
            file: file,
            line: line
        )
    }

}
