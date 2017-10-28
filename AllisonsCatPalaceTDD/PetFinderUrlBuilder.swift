//
//  PetFinderUrlBuilder.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum PetFinderUrlBuilder {

    static let hostname = "api.petfinder.com"
    static let apiKey = "APIKEY"
    static let outputFormat = "json"

    enum PaginationKeys {
        static let offset = "offset"
        static let count = "count"
    }

    enum MethodPaths {
        static let search = "/pet.find"
    }

    enum BaseQueryItemKeys {
        static let apiKey = "key"
        static let outputFormat = "format"
        static let recordLength = "output"
    }

    static func buildSearchUrl(
        searchParameters: PetFinderSearchParameters,
        range cursor: PaginationCursor
        ) -> URL {

        var components = baseApiUrlComponents
        components.path = MethodPaths.search

        var queryItems = components.queryItems ?? []

        queryItems.append(
            contentsOf: searchParameters.queryItems
                .union(cursor.petFinderUrlQueryItems)
                .union([PetFinderRecordLength.short.queryItem])
                .map { $0 }
        )

        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Components should be able to create a valid URL")
        }

        return url
    }

    static let baseApiUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = hostname
        components.queryItems = Array(baseQueryItems)
        return components
    }()

    static let baseQueryItems: Set = [
        URLQueryItem(
            name: BaseQueryItemKeys.apiKey,
            value: apiKey
        ),
        URLQueryItem(
            name: BaseQueryItemKeys.outputFormat,
            value: outputFormat
        )
    ]
}

extension PaginationCursor {
    var petFinderUrlQueryItems: Set<URLQueryItem> {
        return [
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.offset,
                value: String(offset)
            ),
            URLQueryItem(
                name: PetFinderUrlBuilder.PaginationKeys.count,
                value: String(size)
            )
        ]
    }
}
