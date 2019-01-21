//
//  CLGeocoderIsGeocodingStub.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 1/27/18.
//  Copyright © 2018 Joesus. All rights reserved.
//

import CoreLocation
import FoundationSwagger
import TestSwagger

extension CLGeocoder {

    private static let isGeocodingSurrogateString = UUIDKeyString()
    private static let isGeocodingSurrogateKey = ObjectAssociationKey(isGeocodingSurrogateString)

    private var isGeocodingSurrogate: MethodSurrogate? {
        get {
            return association(for: CLGeocoder.isGeocodingSurrogateKey) as? MethodSurrogate
        }
        set {
            guard let surrogate = newValue else {
                return removeAssociation(for: CLGeocoder.isGeocodingSurrogateKey)
            }

            associate(surrogate, with: CLGeocoder.isGeocodingSurrogateKey)
        }
    }

    func beginStubbingIsGeocoding(with isGeocoding: Bool) {

        guard isGeocodingSurrogate == nil else { return }

        stubbedIsGeocoding = isGeocoding

        let surrogate = MethodSurrogate(
            forClass: CLGeocoder.self,
            ofType: .instance,
            originalSelector: #selector(getter: CLGeocoder.isGeocoding),
            alternateSelector: #selector(CLGeocoder.stub_isGeocoding)
        )

        isGeocodingSurrogate = surrogate
        surrogate.useAlternateImplementation()
    }

    func endStubbingIsGeocoding() {
        isGeocodingSurrogate?.useOriginalImplementation()
        isGeocodingSurrogate = nil
        stubbedIsGeocoding = nil
    }

    @objc dynamic func stub_isGeocoding() -> Bool {
        return stubbedIsGeocoding ?? stub_isGeocoding()
    }

    private static let stubbedIsGeocodingString = UUIDKeyString()
    private static let stubbedIsGeocodingKey =
        ObjectAssociationKey(stubbedIsGeocodingString)

    var stubbedIsGeocoding: Bool? {
        get {
            return booleanAssociation(for: CLGeocoder.stubbedIsGeocodingKey)
        }
        set {
            let key = CLGeocoder.stubbedIsGeocodingKey
            guard let status = newValue else {
                return removeAssociation(for: key)
            }

            associate(status, with: key)
        }
    }

}
