//
//  AppDelegate.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import UIKit
import ImageProviding
import ImageProvider
import LocationResolver
import LocationResolving

struct Dependencies {
    static var imageProvider: ImageProviding.Type = ImageProvider.self
    static var locationResolverFactory: () -> LocationResolving = {
        return LocationResolver()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        return true
    }
}
