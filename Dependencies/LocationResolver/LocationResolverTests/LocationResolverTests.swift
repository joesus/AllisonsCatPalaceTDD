//
//  LocationResolverTests.swift
//  LocationResolverTests
//
//  Created by Joe Susnick on 11/17/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LocationResolver
import LocationResolving

class LocationResolverTests: XCTestCase {

    var resolver: LocationResolver!
    let fakeLocationManager = FakeLocationManager()

    override func setUp() {
        super.setUp()

        resolver = LocationResolver(locationManager: fakeLocationManager)
    }

    override func tearDown() {
        FakeLocationManager.reset()

        super.tearDown()
    }

    func testInitialResolutionState() {
        resolver = LocationResolver()

        XCTAssertEqual(resolver.userLocationResolution, .unknown,
                       "The initial user location resolution for a new location resolver should be unknown")
    }

    func testHasLocationManager() {
        resolver = LocationResolver()

        guard let locationManager = resolver.locationManager as? CLLocationManager else {
            return XCTFail("Resolver should have a location manager with a default concrete type provided by Core Location")
        }

        XCTAssertTrue(locationManager.delegate === resolver,
                      "Resolver should be the delegate for its location manager")
    }

    // Mark: Initial State
    func testUserLocationResolutionForDisabledLocationServices() {
        FakeLocationManager.stubbedLocationServicesEnabled = false

        XCTAssertEqual(resolver.userLocationResolution, .disallowed,
                       "Resolver should have a user location resolution with an initial state of disallowed if location services are disabled")
    }

    func testUserLocationResolutionForFirstLaunch() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        XCTAssertEqual(resolver.userLocationResolution, .unknown,
                       "Resolver should have a user location resolution with an initial state of unknown when location services are enabled but authorization status is unknown")
    }

    func testUserLocationResolutionForUnauthorizedPermissions() {
        FakeLocationManager.stubbedAuthorizationStatus = .denied

        XCTAssertEqual(resolver.userLocationResolution, .disallowed,
                       "Resolver should have a user location resolution with an initial state of disallowed if location services authorization has been denied")
    }

    func testUserLocationResolutionForEnabledAndAuthorizedLocationServices() {
        FakeLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse

        XCTAssertEqual(resolver.userLocationResolution, .allowed,
                       "Resolver should have a user location resolution with an initial state of allowed if location services are enabled and authorized")
    }

    func testUserLocationResolutionForEnabledAndOverAuthorizedLocationServices() {
        FakeLocationManager.stubbedAuthorizationStatus = .authorizedAlways

        XCTAssertEqual(resolver.userLocationResolution, .allowed,
                       "Resolver should have a user location resolution with an initial state of allowed if location services are enabled and authorized to the max")
    }

    // MARK: Requesting Authorization

    func testRequestingAuthorizationWhenServicesDisabled() {
        FakeLocationManager.stubbedLocationServicesEnabled = false

        let possibleAuthorizations = [
            CLAuthorizationStatus.notDetermined,
            .denied,
            .restricted,
            .authorizedWhenInUse,
            .authorizedAlways
        ]

        possibleAuthorizations.forEach { status in
            FakeLocationManager.stubbedAuthorizationStatus = status

            resolver.requestLocationAuthorization(for: .whenInUse)

            XCTAssertFalse(fakeLocationManager.requestWhenInUseAuthorizationCalled,
                           "Location manager should never request authorization with location services disabled")
        }
    }

    func testRequestingAuthorizationWhenServicesEnabled() {
        let possibleAuthorizations = [
            CLAuthorizationStatus.denied,
            .restricted,
            .authorizedWhenInUse,
            .authorizedAlways
        ]

        possibleAuthorizations.forEach { status in
            FakeLocationManager.stubbedAuthorizationStatus = status

            resolver.requestLocationAuthorization(for: .whenInUse)

            XCTAssertFalse(fakeLocationManager.requestWhenInUseAuthorizationCalled,
                           "Location manager should never request authorization when status is determined")
        }
    }

    func testRequestingWhenInUseAuthorizationWhenNotDetermined() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        resolver.requestLocationAuthorization(for: .whenInUse)

        XCTAssertTrue(fakeLocationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request when in use authorization if status is not determined")
    }

    func testRequestingAlwaysAuthorizationWhenNotDetermined() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        resolver.requestLocationAuthorization(for: .always)

        XCTAssertTrue(fakeLocationManager.requestAlwaysAuthorizationCalled,
                      "Location manager should request always authorization if status is not determined")
    }

    // MARK: - Requesting Location

    func testRequestingLocationUtilizesLocationManager() {
        resolver.resolveUserLocation { _ in }

        XCTAssertTrue(fakeLocationManager.requestLocationCalled,
                      "Requests for location should be routed through the location manager")
    }

}
