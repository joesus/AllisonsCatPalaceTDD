//
//  PetFinderNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum PetFinderNetworker: AnimalNetworker {
    typealias Response = PetFinderResponse
    typealias SearchParameters = PetFinderSearchParameters

    static var session = URLSession.shared
    static weak var retrieveAllAnimalsTask: URLSessionTask?

    static let desiredNumberOfResults = "20"

    static func findAnimals(
        matching parameters: SearchParameters,
        inRange range: PaginationCursor,
        completion: @escaping (Result<Response>) -> Void
        ) {

        retrieveAllAnimalsTask?.cancel()

        let url = PetFinderUrlBuilder.buildSearchUrl(
            searchParameters: parameters,
            range: range
        )

        let task = session.dataTask(with: url) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleAnimalsRetrieval(data: potentialData, response: response))
            }
        }

        retrieveAllAnimalsTask = task
        task.resume()
    }

    private static func handleAnimalsRetrieval(
        data potentialData: Data?,
        response: HTTPURLResponse
        ) -> Result<PetFinderResponse> {

        switch response.statusCode {
        case 200:
            if let data = potentialData,
                let rawResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                let response = rawResponse as? JsonObject {
                return .success(response)
            } else {
                return Result.failure(AnimalNetworkError.missingData)
            }
        case 404:
            return Result.failure(AnimalNetworkError.missingAnimalService)
        default:
            fatalError("Unexpected status code")
        }
    }

    static func retrieveAnimal(
        withIdentifier identifier: Int,
        completion: @escaping (Result<Response>) -> Void
        ) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.petfinder.com"
        components.queryItems = [
            URLQueryItem(name: "key", value: "APIKEY"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "output", value: "full")
        ]

        components.path = "/pet.get"
        let idQuery = URLQueryItem(name: "id", value: String(identifier))
        components.queryItems?.append(idQuery)

        guard let url = components.url else { return }

        let task = session.dataTask(with: url) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleAnimalRetrieval(for: identifier, data: potentialData, response: response))
            }
        }
        task.resume()
    }

    private static func handleAnimalRetrieval(
        for identifier: Int,
        data potentialData: Data?,
        response: HTTPURLResponse
        ) -> Result<PetFinderResponse> {

        switch response.statusCode {
        case 200:
            if let data = potentialData,
                let rawResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                let response = rawResponse as? PetFinderResponse {
                 return .success(response)
            } else {
                return Result.failure(AnimalNetworkError.missingData)
            }
        case 404:
            return Result.failure(AnimalNetworkError.missingAnimal(identifier: identifier))
        default:
            fatalError("Unexpected status code")
        }
    }
}
