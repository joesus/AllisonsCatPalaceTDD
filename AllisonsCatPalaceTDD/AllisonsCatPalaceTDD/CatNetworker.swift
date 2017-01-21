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

    static func retrieveAllCats(success: CatRetrievalSuccessHandler, failure: CatRetrievalErrorHandler? = nil) {
        session.dataTask(with: URL(string: "http://example.com/cats")!).resume()

    }
}
