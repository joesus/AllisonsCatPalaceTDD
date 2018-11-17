//
//  SearchService.swift
//  AnimalProviding
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData

public protocol SearchService {
    func search(with parameters: SearchParameters) -> [AnimalData]
}
