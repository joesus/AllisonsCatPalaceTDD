//
//  FakeAppDelegate.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/30/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import UIKit

class FakeUrlOpener: UrlOpening {

    var capturedUrl: URL?
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
        ) {

        capturedUrl = url
    }

}
