//
//  SearchServiceTests.swift
//  AnimalProvidingTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalProviding
import AnimalData
import XCTest

struct SampleSearchService: SearchService {
    func search(with parameters: SearchParameters) -> [AnimalData] {
        return []
    }
}

class SearchServiceTests: XCTestCase {

    let sampleSearchService: SearchService = SampleSearchService()
//    let sampleSearchParameters = SampleSearchParameters(species: .dog)

}
