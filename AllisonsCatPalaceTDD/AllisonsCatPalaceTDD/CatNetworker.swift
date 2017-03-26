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
private let CatServiceDomain = "http://example.com/"
private let CatServicePath = "cats"
private let CatServiceDomainUrl = URL(string: CatServiceDomain)!
let CatServiceEndpoint = CatServiceDomainUrl.appendingPathComponent(CatServicePath)

enum CatNetworker {
    static var session = URLSession.shared
    static weak var retrieveAllCatsTask: URLSessionTask?

    static func retrieveAllCats(completion: @escaping CatRetrievalHandler) {
        retrieveAllCatsTask?.cancel()

        let task = session.dataTask(with: CatServiceEndpoint) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleCatsRetrieval(data: potentialData, response: response))
            }

        }

        retrieveAllCatsTask = task
        task.resume()
    }

    private static func handleCatsRetrieval(data potentialData: Data?, response: HTTPURLResponse) -> NetworkResult {

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

    static func retrieveCat(withIdentifier id: Int, completion: @escaping CatRetrievalHandler) {

        let url = CatServiceEndpoint.appendingPathComponent(String(id))

        let task = session.dataTask(with: url) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleCatRetrieval(for: id, data: potentialData, response: response))
            }
        }
        task.resume()
    }

    private static func handleCatRetrieval(for identifier: Int, data potentialData: Data?, response: HTTPURLResponse) -> NetworkResult {

        switch response.statusCode {
        case 200:
            if let data = potentialData {
                return .success(data)
            } else {
                return Result.failure(CatNetworkError.missingData)
            }
        case 404:
            return Result.failure(CatNetworkError.missingCat(identifier: identifier))
        default:
            fatalError()
        }
    }
}
