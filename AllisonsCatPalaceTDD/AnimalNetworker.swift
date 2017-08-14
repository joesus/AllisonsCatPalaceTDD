//
//  PetFinderNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

private var CatServiceComponents: URLComponents = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.petfinder.com"
    components.queryItems = [
        URLQueryItem(name: "key", value: "APIKEY"),
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "output", value: "full")
    ]

    return components
}()

protocol AnimalNetworker {
    associatedtype Response
    associatedtype ResponseHandler = (Result<Response>) -> Void

    static func retrieveAllAnimals(for location: String, completion: ResponseHandler) // TODO - make location a dependent type
    static func retrieveAnimal(withIdentifier id: Int, completion: ResponseHandler)
}

enum PetFinderNetworker {
    typealias ResponseHandler = (Result<PetFinderResponse>) -> Void
    static var session = URLSession.shared
    static weak var retrieveAllAnimalsTask: URLSessionTask?

    static func retrieveAllAnimals(for location: String = "80220", completion: @escaping ResponseHandler)  {
        retrieveAllAnimalsTask?.cancel()

        CatServiceComponents.path = "/pet.find"
        let locationQuery = URLQueryItem(name: "location", value: location)
        if CatServiceComponents.queryItems?.contains(locationQuery) == false {
            CatServiceComponents.queryItems?.append(locationQuery)
        }

        guard let url = CatServiceComponents.url else { return }

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

        CatServiceComponents.path = "/pet.get"
        let idQuery = URLQueryItem(name: "id", value: String(id))
        if CatServiceComponents.queryItems?.contains(idQuery) == false {
            CatServiceComponents.queryItems?.append(idQuery)
        }

        guard let url = CatServiceComponents.url else { return }

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