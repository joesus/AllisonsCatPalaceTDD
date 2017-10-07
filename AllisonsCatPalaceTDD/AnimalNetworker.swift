//
//  PetFinderNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

protocol AnimalNetworker {
    associatedtype Response
    associatedtype ResponseHandler = (Result<Response>) -> Void

    static func retrieveAllAnimals(offset: Int, completion: ResponseHandler)
    static func retrieveAnimal(withIdentifier id: Int, completion: ResponseHandler)
}

enum PetFinderNetworker: AnimalNetworker {
    typealias Response = PetFinderResponse
    typealias ResponseHandler = (Result<PetFinderResponse>) -> Void
    static var session = URLSession.shared
    static weak var retrieveAllAnimalsTask: URLSessionTask?
    static let desiredNumberOfResults = "20"

    static func retrieveAllAnimals(offset: Int = 0, completion: @escaping ResponseHandler)  {
        let location = SettingsManager.shared.value(forKey: .zipCode) as? String ?? ""

        retrieveAllAnimalsTask?.cancel()

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.petfinder.com"
        components.queryItems = [
            URLQueryItem(name: "key", value: "APIKEY"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "output", value: "full"),
            URLQueryItem(name: "count", value: PetFinderNetworker.desiredNumberOfResults)
        ]

        components.path = "/pet.find"
        let locationQuery = URLQueryItem(name: "location", value: location)
        components.queryItems?.append(locationQuery)

        let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
        components.queryItems?.append(offsetQuery)

        guard let url = components.url else { return }

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

    private static func handleAnimalsRetrieval(data potentialData: Data?, response: HTTPURLResponse) -> Result<PetFinderResponse> {

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
            fatalError()
        }
    }

    static func retrieveAnimal(withIdentifier id: Int, completion: @escaping ResponseHandler) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.petfinder.com"
        components.queryItems = [
            URLQueryItem(name: "key", value: "APIKEY"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "output", value: "full")
        ]

        components.path = "/pet.get"
        let idQuery = URLQueryItem(name: "id", value: String(id))
        components.queryItems?.append(idQuery)

        guard let url = components.url else { return }

        let task = session.dataTask(with: url) {
            potentialData, potentialResponse, potentialError in

            if let error = potentialError {
                return completion(.failure(error))
            } else if let response = potentialResponse as? HTTPURLResponse {
                completion(handleAnimalRetrieval(for: id, data: potentialData, response: response))
            }
        }
        task.resume()
    }

    private static func handleAnimalRetrieval(for identifier: Int, data potentialData: Data?, response: HTTPURLResponse) -> Result<PetFinderResponse> {

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
            fatalError()
        }
    }
}
