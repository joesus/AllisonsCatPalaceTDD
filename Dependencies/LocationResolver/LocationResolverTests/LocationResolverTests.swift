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
    var fakeDelegate: FakeLocationResolutionDelegate? = FakeLocationResolutionDelegate()

    override func setUp() {
        super.setUp()

        resolver = LocationResolver()
        resolver.locationManager = fakeLocationManager
        resolver.geocoder = fakeGeocoder
        resolver.delegate = fakeDelegate
    }

    override func tearDown() {
        FakeLocationManager.reset()

        super.tearDown()
    }

    func testSupportsDelegate() {
        resolver = LocationResolver()

        XCTAssertNil(resolver.delegate,
                     "Resolver should not have a location resolution delegate by default")
        resolver.delegate = fakeDelegate

        assert(resolver.delegate === fakeDelegate,
               "Resolver should hold a reference to the set delegate")

        fakeDelegate = nil
        XCTAssertNil(resolver.delegate,
                     "Resolver should not hold a strong reference to its delegate")
    }

    func testInitialLocationResolvability() {
        XCTAssertEqual(resolver.userLocationResolvability, .unknown,
                       "The initial user location resolution for a new location resolver should be unknown")
    }

    func testInitialResolutionState() {
        XCTAssertNil(resolver.locationResolution,
                     "There should not be an initial user location resolution")
    }

    func testHasLocationManager() {
        resolver = LocationResolver()

        guard let locationManager = resolver.locationManager as? CLLocationManager else {
            return XCTFail("Resolver should have a location manager with a default concrete type provided by Core Location")
        }

        XCTAssertTrue(locationManager.delegate === resolver,
                      "Resolver should be the delegate for its location manager")
    }

    // MARK: - Initial State

    func testUserLocationResolvabilityForDisabledLocationServices() {
        FakeLocationManager.stubbedLocationServicesEnabled = false

        XCTAssertEqual(resolver.userLocationResolvability, .disallowed,
                       "Resolver should indicate that it cannot resolve the user's location if location services are disabled")
    }

    func testUserLocationResolvabilityForFirstLaunch() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        XCTAssertEqual(resolver.userLocationResolvability, .unknown,
                       "Resolver should indicate that it does not know whether it can resolve the user's location if location services are enabled but authorization status is unknown")
    }

    func testUserLocationResolvabilityForUnauthorizedPermissions() {
        FakeLocationManager.stubbedAuthorizationStatus = .denied

        XCTAssertEqual(resolver.userLocationResolvability, .disallowed,
                       "Resolver should indicate that it cannot resolve the user's location if location services authorization has been denied")
    }

    func testUserLocationResolvabilityForRestrictedPermissions() {
        FakeLocationManager.stubbedAuthorizationStatus = .restricted

        XCTAssertEqual(resolver.userLocationResolvability, .disallowed,
                       "Resolver should indicate that it cannot resolve the user's location if location services authorization has been restricted")
    }

    func testUserLocationResolvabilityForAuthorizedWhenInUsePermissions() {
        FakeLocationManager.stubbedAuthorizationStatus = .authorizedWhenInUse

        XCTAssertEqual(resolver.userLocationResolvability, .allowed,
                       "Resolver should indicate that it can resolve the user's location if location services are enabled and authorized when in use")
    }

    func testUserLocationResolvabilityForAuthorizedAlwaysPermissions() {
        FakeLocationManager.stubbedAuthorizationStatus = .authorizedAlways

        XCTAssertEqual(resolver.userLocationResolvability, .allowed,
                       "Resolver should indicate that it can resolve the user's location if location services are enabled and always authorized")
    }

    // MARK: - Requesting Authorization

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

            resolver.requestUserLocationAuthorization(for: .whenInUse)

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

            resolver.requestUserLocationAuthorization(for: .whenInUse)

            XCTAssertFalse(fakeLocationManager.requestWhenInUseAuthorizationCalled,
                           "Location manager should never request authorization when status is determined")
        }
    }

    func testRequestingWhenInUseAuthorizationWhenNotDetermined() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        resolver.requestUserLocationAuthorization(for: .whenInUse)

        XCTAssertTrue(fakeLocationManager.requestWhenInUseAuthorizationCalled,
                      "Location manager should request when in use authorization if status is not determined")
    }

    func testRequestingAlwaysAuthorizationWhenNotDetermined() {
        FakeLocationManager.stubbedAuthorizationStatus = .notDetermined

        resolver.requestUserLocationAuthorization(for: .always)

        XCTAssertTrue(fakeLocationManager.requestAlwaysAuthorizationCalled,
                      "Location manager should request always authorization if status is not determined")
    }

    // MARK: - Requesting Location

    func testRequestingLocationUtilizesLocationManager() {
        resolver.resolveUserLocation()

        XCTAssertNil(resolver.locationResolution,
                     "Resolving a location shouldn't set the resolution before completing")
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
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)

        XCTAssertEqual(fakeGeocoder.locationToReverseGeocode, locations.last!,
                       "Geocoder should be called with the last location received")
    }

    func testGeocodingWithError() {
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(nil, SampleError())

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should complete with a failed user location resolution"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should update user location resolution"
        )
    }

    func testGeocodingWithNilPlacemarks() {
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(nil, nil)

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should complete with a failed user location resolution"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should update user location resolution"
        )
    }

    func testGeocodingWithEmptyPlacemarks() {
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?([], nil)

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should complete with a failed user location resolution"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Failure to geocode should update user location resolution"
        )
    }

    func testSubsequentUserLocationRequestsAfterFailure() {
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?([], nil)

        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Sanity check failed"
        )

        resolver.resolveUserLocation()

        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "Previous results should be maintained until the new resolution is completed"
        )
    }

    func testSuccessfulGeocoding() {
        resolver.resolveUserLocation()

        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolved(placemark: SamplePlacemarks.detroit, date: Date()),
            "A successful geocoding should complete with a resolved resolution with the received placemark"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolved(placemark: SamplePlacemarks.detroit, date: Date()),
            "A successful geocoding should update the user location resolution with the received placemark"
        )
    }

    func testFindingPlacemarkWithValidStringUsesGeocoder() {
        let locationString = "ohio"
        resolver.resolveLocation(for: locationString)

        XCTAssertEqual(locationString, fakeGeocoder.stringToGeocode,
                       "Finding a placemark with a string should pass the string to its geocoder")
    }

    func testHandlingGeocodeError() {
        resolver.resolveLocation(for: "foo")
        fakeGeocoder.capturedCompletionHandler?(nil, SampleError())

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "A geocoding error should result in an unknown location resolution failure"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .unknown, date: Date()),
            "A geocoding error should set the resolver's resolution state to an unknown location resolution failure"
        )
    }

    func testHandlingNilPlacemarks() {
        resolver.resolveLocation(for: "foo")

        fakeGeocoder.capturedCompletionHandler?(nil, nil)

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .locationNotFound, date: Date()),
            "A nil placemark should result in a `location not found` resolution failure"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .locationNotFound, date: Date()),
            "A nil placemark should result in a `location not found` resolution state"
        )
    }

    func testHandlingEmptyPlacemarks() {
        resolver.resolveLocation(for: "foo")

        fakeGeocoder.capturedCompletionHandler?([], nil)

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolutionFailed(error: .locationNotFound, date: Date()),
            "An empty list of placemarks should result in a `location not found` resolution failure"
        )
        assertEqualLocationResolutions(
            resolver.locationResolution,
            .resolutionFailed(error: .locationNotFound, date: Date()),
            "An empty list of placemarks should result in a `location not found` resolution state"
        )
    }

    func testHandlingSuccessfulGeocoding() {
        resolver.resolveLocation(for: "foo")

        fakeGeocoder.capturedCompletionHandler?(
            [SamplePlacemarks.denver, SamplePlacemarks.detroit],
            nil
        )

        assertEqualLocationResolutions(
            fakeDelegate?.capturedLocationResolution,
            .resolved(placemark: SamplePlacemarks.denver, date: Date()),
            "Finding a placemark should use the first placemark returned by the geocoder"
        )
    }

    func testNotResolvingUserLocationWhileResolvingUserLocation() {
        // Initial attempt
        resolver.resolveUserLocation()
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")

        // Blocked attempt
        resolver.resolveUserLocation()
        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 1,
                       "Should not make additional location requests while a resolution is in progress")

        // Resolve initial attempt
        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(nil, nil)
        XCTAssertFalse(resolver.isResolvingLocation,
                       "Should clear the flag to indicate that a resolution is no longer in progress")

        // Allowed attempt
        resolver.resolveUserLocation()
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")
        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 2,
                       "Should make additional location requests while a resolution is not in progress")
    }

    func testNotFindingLocationWhileResolvingUserLocation() {
        // Initial attempt
        resolver.resolveUserLocation()
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")

        // Blocked attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertEqual(fakeGeocoder.geocodeAddressStringCallCount, 0,
                       "Should not attempt to geocode an address while a resolution is in progress")

        // Resolve initial attempt
        resolver.locationManager(CLLocationManager(), didUpdateLocations: locations)
        fakeGeocoder.capturedCompletionHandler?(nil, nil)
        XCTAssertFalse(resolver.isResolvingLocation,
                       "Should clear the flag to indicate that a resolution is no longer in progress")

        // Allowed attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")
        XCTAssertEqual(fakeGeocoder.geocodeAddressStringCallCount, 1,
                       "Should attempt to geocode an address if a resolution is in not progress")
    }

    func testNotFindingLocationWhileFindingLocation() {
        // Initial attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")

        // Blocked attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertEqual(fakeGeocoder.geocodeAddressStringCallCount, 1,
                       "Should not attempt to geocode an address while a resolution is in progress")

        // Resolve initial attempt
        fakeGeocoder.capturedCompletionHandler?(nil, nil)
        XCTAssertFalse(resolver.isResolvingLocation,
                       "Should clear the flag to indicate that a resolution is no longer in progress")

        // Allowed attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")
        XCTAssertEqual(fakeGeocoder.geocodeAddressStringCallCount, 2,
                       "Should attempt to geocode an address if a resolution is in not progress")
    }

    func testNotResolvingUserLocationWhileFindingLocation() {
        // Initial attempt
        resolver.resolveLocation(for: "foo")
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")

        // Blocked attempt
        resolver.resolveUserLocation()
        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 0,
                       "Should not make a location request while a resolution is in progress")

        // Resolve initial attempt
        fakeGeocoder.capturedCompletionHandler?(nil, nil)
        XCTAssertFalse(resolver.isResolvingLocation,
                       "Should clear the flag to indicate that a resolution is no longer in progress")

        // Allowed attempt
        resolver.resolveUserLocation()
        XCTAssertTrue(resolver.isResolvingLocation,
                      "Should set a flag to indicate when a resolution is in progress")
        XCTAssertEqual(fakeLocationManager.requestLocationCallCount, 1,
                       "Should make a location request while a resolution is not in progress")
    }

}

extension LocationResolverTests {

    func assertEqualLocationResolutions(
        _ lhs: LocationResolution?,
        _ rhs: LocationResolution?,
        _ message: @autoclosure () -> String,
        inFile file: StaticString = #file,
        atLine line: UInt = #line
        ) {

        switch (lhs, rhs) {
        case (
            let .resolved(leftPlacemark, leftDate)?,
            let .resolved(rightPlacemark, rightDate)?
            ):

            XCTAssertEqual(leftPlacemark, rightPlacemark, message, file: file, line: line)
            XCTAssertEqual(
                leftDate.timeIntervalSinceReferenceDate,
                rightDate.timeIntervalSinceReferenceDate,
                accuracy: 0.001,
                message,
                file: file,
                line: line
            )

        case (
            let .resolutionFailed(leftError, leftDate)?,
            let .resolutionFailed(rightError, rightDate)?
            ):

            XCTAssertEqual(leftError, rightError, message, file: file, line: line)
            XCTAssertEqual(
                leftDate.timeIntervalSinceReferenceDate,
                rightDate.timeIntervalSinceReferenceDate,
                accuracy: 0.01,
                message,
                file: file,
                line: line
            )

        default:
            XCTFail(message(), file: file, line: line)
        }
    }
}
