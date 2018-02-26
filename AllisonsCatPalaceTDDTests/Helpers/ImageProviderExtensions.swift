//
//  ImageProviderExtensions.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 3/11/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

extension ImageProvider {
    static func reset() {
        cache.removeAllCachedResponses()
        currentRequestUrls.removeAll()
        knownMissingImageUrls.removeAll()
    }
}
