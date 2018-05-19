//
//  FakeImageProvider.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 5/19/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import Foundation

class FakeImageProvider: ImageProviding {
    static var capturedURL: URL?

    static func getImage(for url: URL, completion: @escaping ImageCompletion) {
        capturedURL = url
    }

}
