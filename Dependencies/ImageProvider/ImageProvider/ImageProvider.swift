//
//  ImageProvider.swift
//  ImageProvider
//
//  Created by Joesus on 2/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import ImageProviding

// TODO: Retry image fetch for missing images on network availability changes

public enum ImageProvider: ImageProviding {
    static var session = URLSession.shared
    static let cache = URLCache.shared
    static var knownMissingImageUrls = Set<URL>()
    static var currentRequestUrls = Set<URL>()

    public static func image(for url: URL) -> UIImage? {
        guard let response = cache.cachedResponse(for: URLRequest(url: url)) else {
            return nil
        }

        return UIImage(data: response.data)
    }

    public static func getImage(for url: URL, completion: @escaping ImageCompletion) {
        guard !knownMissingImageUrls.contains(url),
            !currentRequestUrls.contains(url) else {
                return completion(nil)
        }

        if let image = image(for: url) {
            completion(image)
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { potentialData, potentialResponse, _ in

            guard let response = potentialResponse as? HTTPURLResponse else {
                currentRequestUrls.remove(url)
                return completion(nil)
            }

            switch response.statusCode {
            case 404:
                knownMissingImageUrls.insert(url)
                completion(nil)
            case 200:
                handleSuccessfulResponse(response, for: request, data: potentialData, completion: completion)
            default:
                completion(nil)
            }

            currentRequestUrls.remove(url)
        }

        currentRequestUrls.insert(url)
        task.resume()
    }

    static private func handleSuccessfulResponse(
        _ response: HTTPURLResponse,
        for request: URLRequest,
        data potentialData: Data?,
        completion: @escaping ImageCompletion
        ) {

        guard let data = potentialData else {
            return completion(nil)
        }

        if let image = UIImage(data: data) {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            completion(image)
        } else {
            completion(nil)
        }
    }
}
