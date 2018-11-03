//
//  ImageProviding.swift
//  ImageProviding
//
//  Created by Joe Susnick on 11/3/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import UIKit

public protocol ImageProviding {
    static func getImage(for: URL, completion: @escaping ImageCompletion)
    static func image(for: URL) -> UIImage?
}

public typealias ImageCompletion = (UIImage?) -> Void
