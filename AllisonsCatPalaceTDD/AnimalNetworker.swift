//
//  AnimalNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias NetworkResult = Result<Data>
typealias AnimalRetrievalHandler = (NetworkResult) -> Void
private let CatServiceEndpoint: URL = {
    var url = URLComponents()
    url.scheme = "https"
    url.host = "api.petfinder.com"
    url.path = "/shelter.getPets"
    url.queryItems = [
        URLQueryItem(name: "id", value: "CO316"),
        URLQueryItem(name: "key", value: "APIKEY"),
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "output", value: "full")
    ]

    return url.url!
}()

enum AnimalNetworker {
    static var session = URLSession.shared
    static weak var retrieveAllCatsTask: URLSessionTask?

    static func retrieveAllAnimals(completion: @escaping AnimalRetrievalHandler) {
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
                return Result.failure(AnimalNetworkError.missingData)
            }
        case 404:
            return Result.failure(AnimalNetworkError.missingAnimalService)
        default:
            fatalError()
        }
    }

    static func retrieveAnimal(withIdentifier id: Int, completion: @escaping AnimalRetrievalHandler) {

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
                return Result.failure(AnimalNetworkError.missingData)
            }
        case 404:
            return Result.failure(AnimalNetworkError.missingAnimal(identifier: identifier))
        default:
            fatalError()
        }
    }
}
