//
//  LocationServicesEnabledStub.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 12/3/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import CoreLocation
import FoundationSwagger
import TestSwagger

extension CLLocationManager {

    private static let locationServicesEnabledSurrogateString = UUIDKeyString()
    private static let locationServicesEnabledSurrogateKey = ObjectAssociationKey(
        locationServicesEnabledSurrogateString
    )

    private class var locationServicesEnabledSurrogate: MethodSurrogate? {
        get {
            return association(for: locationServicesEnabledSurrogateKey) as? MethodSurrogate
        }
        set {
            guard let surrogate = newValue else {
                return removeAssociation(for: locationServicesEnabledSurrogateKey)
            }

            associate(surrogate, with: locationServicesEnabledSurrogateKey)
        }
    }

    class func beginStubbingLocationServicesEnabled(with enabled: Bool) {

        guard locationServicesEnabledSurrogate == nil else { return }

        stubbedLocationServicesEnabled = enabled

        let surrogate = MethodSurrogate(
            forClass: CLLocationManager.self,
            ofType: .class,
            originalSelector: #selector(CLLocationManager.locationServicesEnabled),
            alternateSelector: #selector(CLLocationManager.stub_locationServicesEnabled)
        )

        locationServicesEnabledSurrogate = surrogate
        surrogate.useAlternateImplementation()
    }

    class func endStubbingLocationServicesEnabled() {
        locationServicesEnabledSurrogate?.useOriginalImplementation()
        locationServicesEnabledSurrogate = nil
        stubbedLocationServicesEnabled = nil
    }

    @objc dynamic class func stub_locationServicesEnabled() -> Bool {
        return stubbedLocationServicesEnabled ?? stub_locationServicesEnabled()
    }

    private static let stubbedLocationServicesEnabledString = UUIDKeyString()
    private static let stubbedLocationServicesEnabledKey =
        ObjectAssociationKey(stubbedLocationServicesEnabledString)

    class var stubbedLocationServicesEnabled: Bool? {
        get {
            return booleanAssociation(for: CLLocationManager.stubbedLocationServicesEnabledKey)
        }
        set {
            let key = CLLocationManager.stubbedLocationServicesEnabledKey
            guard let status = newValue else {
                return removeAssociation(for: key)
            }

            associate(status, with: key)
        }
    }

}
