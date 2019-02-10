//
//  UrlOpening.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/30/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import UIKit

protocol UrlOpening: class {
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any],
        completionHandler completion: ((Bool) -> Void)?
    )
}

extension UIApplication: UrlOpening {}
