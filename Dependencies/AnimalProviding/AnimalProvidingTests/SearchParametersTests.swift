//
//  SearchParametersTests.swift
//  AnimalProvidingTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalProviding
import AnimalData
import CoreLocation
import XCTest

struct SampleSearchParameters: SearchParameters {
    let location: CLPlacemark
    let species: Species?
}

class SearchParametersTests: XCTestCase {

    let sampleSearchParameters: SearchParameters = SampleSearchParameters(
        location: SamplePlacemarks.denver,
        species: .dog
    )

    func testSpecies() {
        XCTAssertEqual(sampleSearchParameters.location, SamplePlacemarks.denver,
                       "Search parameters interface requires a location")
        XCTAssertEqual(sampleSearchParameters.species, .dog,
                       "Search parameters interface requires a species")
    }

}
