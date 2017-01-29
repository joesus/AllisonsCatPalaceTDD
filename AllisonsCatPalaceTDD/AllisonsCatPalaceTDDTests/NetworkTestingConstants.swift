//
//  TestErrors.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

let fakeNetworkError = NSError(domain: "CatPalaceTesting", code: 101, userInfo: nil)

let missingCatResponse = HTTPURLResponse(
        url: URL(string: "http://example.com")!,
        statusCode: 404,
        httpVersion: nil,
        headerFields: nil
)

let successfulCatResponse = HTTPURLResponse(
    url: URL(string: "http://example.com")!,
    statusCode: 200,
    httpVersion: nil,
    headerFields: nil
)
