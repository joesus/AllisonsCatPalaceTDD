//
//  LocationResolutionTests.swift
//  LocationResolvingTests
//
//  Created by Joe Susnick on 12/10/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import LocationResolving
import CoreLocation
import XCTest

class LocationResolutionTests: XCTestCase {

    let placemark = SamplePlacemarks.denver

    func testAllCases() {
        let possibleValues: [LocationResolution] = [
        .resolved(placemark: placemark, date: Date()),
        .resolutionFailed(error: .unknown, date: Date())
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolved, .resolutionFailed:
                break
            }
        }
    }

    func testError() {
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark, date: Date()),
            .resolutionFailed(error: .unknown, date: Date())
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolved:
                XCTAssertNil(value.error,
                             "Resolution states that do not have an associated error should not provide an error")

            case .resolutionFailed(let error, _):
                XCTAssertEqual(value.error, error,
                               "Resolution failures should provide their associated error")
            }
        }
    }

    func testPlacemark() {
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark, date: Date()),
            .resolutionFailed(error: .unknown, date: Date())
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolutionFailed:
                XCTAssertNil(value.placemark,
                             "Resolution states that do not have an associated placemark should not provide a placemark")

            case .resolved(let placemark, _):
                XCTAssertEqual(value.placemark, placemark,
                               "Resolution success should provide its associated placemark")
            }
        }
    }

    func testDate() {
        let date = Date()
        let possibleValues: [LocationResolution] = [
            .resolved(placemark: placemark, date: date),
            .resolutionFailed(error: .unknown, date: date)
        ]

        possibleValues.forEach { value in
            switch value {
            case .resolutionFailed(_, let date):
                XCTAssertEqual(value.date, date,
                               "Resolution failure should provide its time of failure")

            case .resolved(_, let date):
                XCTAssertEqual(value.date, date,
                               "Resolution success should provide its time of success")
            }
        }
    }

}
