//
//  CatNetworker.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

typealias CatRetrievalSuccessHandler = ([ExternalCat]) -> Void
typealias CatRetrievalErrorHandler = (Error) -> Void

enum CatNetworker {
    static var session = URLSession.shared
    static weak var retrieveAllCatsTask: URLSessionTask?

    static func retrieveAllCats(success: CatRetrievalSuccessHandler, failure: CatRetrievalErrorHandler? = nil) {
        retrieveAllCatsTask?.cancel()

        let task = session.dataTask(with: URL(string: "http://example.com/cats")!)
        retrieveAllCatsTask = task
        task.resume()
    }
}
