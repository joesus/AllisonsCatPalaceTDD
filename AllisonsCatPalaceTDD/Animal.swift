//
//  Animal.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joesus on 1/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalObject: Object {
    dynamic var name: String? = nil
    var identifier = RealmOptional<Int>()
    dynamic var about: String? = nil
    dynamic var adoptionStatus: AnimalAdoptionStatusObject?
    dynamic var age: AnimalAgeGroupObject?
    dynamic var city: String? = nil
    dynamic var sex: AnimalSexObject?
    dynamic var genotype: AnimalGenotypeObject?
    dynamic var stateCode: String? = nil
    dynamic var size: AnimalSizeObject?
    dynamic var imageLocations: AnimalImageLocationsObject?

    override class func primaryKey() -> String? {
        return "identifier"
    }
}

final class Animal {

    let name: String
    let identifier: Int
    var about: String? {
        didSet {
            guard let value = about,
                !value.isEmpty else {
                about = nil
                return
            }
        }
    }
    var adoptionStatus: AnimalAdoptionStatus?
    var isAdoptable: Bool {
        return adoptionStatus?.isAdoptable ?? false
    }
    var age: AnimalAgeGroup?
    var city: String? {
        didSet {
            guard let value = city,
                !value.isEmpty else {
                city = nil
                return
            }
        }
    }
    var sex = AnimalSex.unknown
    var genotype: AnimalGenotype?
    var stateCode: String? {
        didSet {
            guard let value = stateCode else { return }

            let range = NSRange(location: 0, length: value.characters.count)
            let regex = try? NSRegularExpression(pattern: "^[:alpha:]{2}$", options: [])
            guard let matches = regex?.matches(in: value, options: [], range: range),
                !matches.isEmpty else {
                stateCode = nil
                return
            }

            stateCode = value.uppercased()
        }
    }
    var size: AnimalSize?
    var imageLocations = AnimalImageLocations()

    init(name: String, identifier: Int, imageUrl: URL? = nil) {
        self.name = name
        self.identifier = identifier
    }
}

extension Animal: Persistable {
    typealias ManagedObject = AnimalObject

    var managedObject: ManagedObject {
        let object = ManagedObject()

        object.name = name
        object.identifier = RealmOptional<Int>(identifier)
        object.about = about
        object.adoptionStatus = adoptionStatus?.managedObject
        object.age = age?.managedObject
        object.city = city
        object.sex = sex.managedObject
        object.genotype = genotype?.managedObject
        object.stateCode = stateCode
        object.size = size?.managedObject
        object.imageLocations = imageLocations.managedObject

        return object
    }

    convenience init?(managedObject: ManagedObject) {

        guard let name = managedObject.name,
            let identifier = managedObject.identifier.value else {
                return nil
        }

        self.init(name: name, identifier: identifier)
        if let statusObject = managedObject.adoptionStatus {
            adoptionStatus = AnimalAdoptionStatus(managedObject: statusObject)
        }

        if let ageObject = managedObject.age {
            age = AnimalAgeGroup(managedObject: ageObject)
        }

        city = managedObject.city

        if let sexObject = managedObject.sex,
            let sex = AnimalSex(managedObject: sexObject) {
            self.sex = sex
        }

        if let genotypeObject = managedObject.genotype {
            genotype = AnimalGenotype(managedObject: genotypeObject)
        }

        stateCode = managedObject.stateCode

        if let sizeObject = managedObject.size {
            size = AnimalSize(managedObject: sizeObject)
        }
    }
}
