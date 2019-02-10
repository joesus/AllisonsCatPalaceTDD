//
//  UserInterfaceIdentifiers.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 12/24/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import UIKit

typealias SceneIdentifier = String

enum UserInterfaceIdentifiers {

    enum StoryboardIdentifiers {
        static let main = "Main"
    }

    enum SegueIdentifiers {
        static let showFavorites: SegueIdentifier = "ShowFavorites"
    }

    enum SceneIdentifiers {
        static let locationResolution: SceneIdentifier = "LocationResolutionScene"
        static let favorites: SceneIdentifier = "FavoritesScene"
        static let animalDetails: SceneIdentifier = "AnimalDetailsScene"
        static let searchResults: SceneIdentifier = "SearchResultsScene"
    }

}
