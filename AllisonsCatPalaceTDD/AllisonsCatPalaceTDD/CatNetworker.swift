//
//  CatNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias NetworkResult = Result<Data>
typealias CatRetrievalHandler = (NetworkResult) -> Void

enum CatNetworker {
    static var session = URLSession.shared
    static weak var retrieveAllCatsTask: URLSessionTask?

    static func retrieveAllCats(completion: @escaping CatRetrievalHandler) {
        retrieveAllCatsTask?.cancel()

        let task = session.dataTask(with: URL(string: "http://example.com/cats")!) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleCatRetrieval(data: potentialData, response: response))
            }

        }

        retrieveAllCatsTask = task
        task.resume()
    }

    private static func handleCatRetrieval(data potentialData: Data?, response: HTTPURLResponse) -> NetworkResult {

        switch response.statusCode {
        case 200:
            if let data = potentialData {
                return .success(data)
            } else {
                return Result.failure(CatNetworkError.missingData)
            }
        case 404:
            return Result.failure(CatNetworkError.missingCatService)
        default:
            fatalError()
        }
    }
}
