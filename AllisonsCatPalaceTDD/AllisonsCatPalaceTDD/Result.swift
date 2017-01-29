//
//  Result.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
