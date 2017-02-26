//
//  ImageProvider.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 2/25/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import UIKit

enum ImageProvider {
    static let cache = URLCache.shared

    static func getImages(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { potentialData, potentialResponse, _ in
            guard let response = potentialResponse as? HTTPURLResponse,
                response.statusCode == 200,
                let data = potentialData else {
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

        task.resume()
    }
}
