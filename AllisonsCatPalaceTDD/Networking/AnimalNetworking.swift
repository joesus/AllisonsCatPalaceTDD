//
//  AnimalNetworking.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

protocol AnimalNetworker {
    associatedtype Response
    associatedtype SearchParameters

    static func findAnimals(
        matching: SearchParameters,
        inRange: PaginationCursor,
        completion: @escaping (Result<Response>) -> Void
    )
    static func retrieveAnimal(withIdentifier id: Int, completion: @escaping (Result<Response>) -> Void)
}
