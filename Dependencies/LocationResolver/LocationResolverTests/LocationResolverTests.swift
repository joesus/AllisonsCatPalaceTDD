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

    var resolver = LocationResolver()
    let fakeLocationManager = FakeLocationManager()
    let fakeGeocoder = FakeGeocoder()

    override func setUp() {
        super.setUp()

        resolver = LocationResolver()
        resolver.locationManager = fakeLocationManager
        resolver.geocoder = fakeGeocoder
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

        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 1,
                       "Requests for location should be routed through the location manager")
    }

    // MARK: - Geocoding

    let locations = [
        CLLocation(latitude: 0, longitude: 0),
        CLLocation(latitude: 1, longitude: 1),
        CLLocation(latitude: 2, longitude: 2)
    ]

    func testGeocoderIsCalledOnLocationReceipt() {
        let resolvedExpectation = expectation(description: "User location resolved")
        resolver.resolveUserLocation { resolution in
            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        guard fakeGeocoder.locationToReverseGeocode == locations.last! else {
            return XCTFail("Geocoder should be called with the last location received")
        }

        fakeGeocoder.capturedCompletionHandler?(nil, nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGeocodingWithError() {
        let resolvedExpectation = expectation(description: "User location resolved")
        resolver.resolveUserLocation { resolution in
            XCTAssertEqual(resolution, .resolutionFailed(error: .unknown),
                           "Failure to geocode should update user location resolution")

            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        fakeGeocoder.capturedCompletionHandler?(nil, SampleError())

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGeocodingWithNilPlacemarks() {
        let resolvedExpectation = expectation(description: "User location resolved")
        resolver.resolveUserLocation { resolution in
            XCTAssertEqual(resolution, .resolutionFailed(error: .unknown),
                           "Failure to geocode should update user location resolution")

            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        fakeGeocoder.capturedCompletionHandler?(nil, nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGeocodingWithEmptyPlacemarks() {
        let resolvedExpectation = expectation(description: "User location resolved")
        resolver.resolveUserLocation { resolution in
            XCTAssertEqual(resolution, .resolutionFailed(error: .unknown),
                           "Failure to geocode should update user location resolution")

            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        fakeGeocoder.capturedCompletionHandler?([], nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSuccessfulGeocoding() {
        let resolvedExpectation = expectation(description: "User location resolved")
        resolver.resolveUserLocation { resolution in
            XCTAssertEqual(resolution, .resolved(placemark: SamplePlacemarks.detroit),
                           "A successful geocoding should update user location resolution with the received placemark")

            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testMultipleLocationRequests() {
        let firstRequestExpectation = expectation(description: "First request complete")
        let secondRequestExpectation = expectation(description: "Second request complete")

        var receivedError: LocationResolutionError?

        resolver.resolveUserLocation { resolution in
            if let error = resolution.error {
                receivedError = error
            }
            firstRequestExpectation.fulfill()
        }
        resolver.resolveUserLocation { resolution in
            if let error = resolution.error {
                receivedError = error
            }
            secondRequestExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 1,
                       "Location manager should only request location when there is no pending location request")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(receivedError, .requestInProgress,
                       "Duplicate requests should prompt a request in progress error")

        resolver.resolveUserLocation { _ in }

        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 2,
                       "Location manager should request a location when there are no pending location requests")
    }

    func testCompletionHandlerNotPersistedBetweenRequests() {
        let resolvedExpectation = expectation(description: "User location resolved")
        var resolved = false

        resolver.resolveUserLocation { resolution in
            guard !resolved else {
                return XCTFail("")
            }

            resolved = true
            resolvedExpectation.fulfill()
        }

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        waitForExpectations(timeout: 1, handler: nil)

        resolved = false
        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )
        XCTAssertFalse(resolved,
                       "Geocoding closure should not be persisted between requests.")
    }

    func testFindingPlacemarkWithValidStringUsesGeocoder() {
        let locationString = "ohio"
        resolver.findPlacemark(for: locationString) { _ in }

        XCTAssertEqual(locationString, fakeGeocoder.stringToGeocode,
                       "Finding a placemark with a string should pass the string to its geocoder")
    }

    func testHandlingGeocodeError() {
        let resolvedExpectation = expectation(description: name)

        resolver.findPlacemark(for: "foo") { potentialPlacemark in
            XCTAssertNil(potentialPlacemark,
                         "No placemark should be returned when geocoding results in an error")
            resolvedExpectation.fulfill()
        }

        fakeGeocoder.capturedCompletionHandler?(nil, SampleError())

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandlingNilPlacemarks() {
        let resolvedExpectation = expectation(description: name)

        resolver.findPlacemark(for: "foo") { potentialPlacemark in
            XCTAssertNil(potentialPlacemark,
                         "No placemark should be returned when geocoding results in a nil placemark")
            resolvedExpectation.fulfill()
        }

        fakeGeocoder.capturedCompletionHandler?(nil, nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandlingEmptyPlacemarks() {
        let resolvedExpectation = expectation(description: name)

        resolver.findPlacemark(for: "foo") { potentialPlacemark in
            XCTAssertNil(potentialPlacemark,
                         "No placemark should be returned when geocoding results in an empty list of placemarks")
            resolvedExpectation.fulfill()
        }

        fakeGeocoder.capturedCompletionHandler?([], nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandlingSuccessfulGeocoding() {
        let resolvedExpectation = expectation(description: name)

        resolver.findPlacemark(for: "foo") { potentialPlacemark in
            XCTAssertEqual(SamplePlacemarks.denver, potentialPlacemark,
                           "Finding a placemark should use the first placemark returned by the geocoder")
            resolvedExpectation.fulfill()
        }

        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        waitForExpectations(timeout: 1, handler: nil)
    }

}
