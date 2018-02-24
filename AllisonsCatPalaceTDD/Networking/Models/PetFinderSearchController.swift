//
//  PetFinderSearchController.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 11/5/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

class PetFinderSearchController {

    var results = [Animal]()
    var resultsKnownToBeExhausted = false
    private let finderProxy: AnimalFinding.Type
    private let criteria: PetFinderSearchParameters
    var cursor: PaginationCursor
    private let completionHandler: ([Int]) -> Void

    init(
        with criteria: PetFinderSearchParameters,
        pageSize: Int,
        finderProxy: AnimalFinding.Type,
        completion: @escaping ([Int]) -> Void
        ) {

        self.finderProxy = finderProxy
        self.criteria = criteria
        completionHandler = completion
        cursor = PaginationCursor(size: pageSize)
    }

    func getMoreResults() {
        guard !resultsKnownToBeExhausted else { return }

        finderProxy.findAnimals(
            matching: criteria,
            cursor: cursor
        ) { [weak self] animals in

            guard let strongSelf = self else {
                return
            }

            strongSelf.resultsKnownToBeExhausted = animals.count < strongSelf.cursor.size

            let priorResultCount = strongSelf.results.count

            strongSelf.results = animals
            let indices = animals.indices.map { $0.advanced(by: priorResultCount) }

            strongSelf.cursor = strongSelf.cursor.nextPage()

            strongSelf.completionHandler(indices)
        }
    }

}
