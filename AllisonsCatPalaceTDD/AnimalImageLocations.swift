//
//  AnimalImageLocations.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 7/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalImageLocationsObject: Object {
    dynamic var small = Data()
    dynamic var medium = Data()
    dynamic var large = Data()
}

struct AnimalImageLocations {
    let small: [URL]
    let medium: [URL]
    let large: [URL]

    init(
        small: [URL] = [],
        medium: [URL] = [],
        large: [URL] = []
        ) {

        self.small = small.removingDuplicates()
        self.medium = medium.removingDuplicates()
        self.large = large.removingDuplicates()
    }

}

extension AnimalImageLocations: Persistable {
    typealias ManagedObject = AnimalImageLocationsObject

    var managedObject: AnimalImageLocationsObject {
        let locations = AnimalImageLocationsObject()

        locations.small = NSKeyedArchiver.archivedData(withRootObject: small)
        locations.medium = NSKeyedArchiver.archivedData(withRootObject: medium)
        locations.large = NSKeyedArchiver.archivedData(withRootObject: large)

        return locations
    }

    init(managedObject: ManagedObject) {
        let small = NSKeyedUnarchiver.unarchiveObject(with: managedObject.small) as? [URL] ?? []
        let medium = NSKeyedUnarchiver.unarchiveObject(with: managedObject.medium) as? [URL] ?? []
        let large = NSKeyedUnarchiver.unarchiveObject(with: managedObject.large) as? [URL] ?? []

        self.init(small: small, medium: medium, large: large)
    }
}
