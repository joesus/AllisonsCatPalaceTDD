//
//  UIResponderIsFirstResponderStub.swift
//  MassRoots
//
//  Created by Sam Odom on 5/15/17.
//  Copyright © 2017 MassRoots, Inc. All rights reserved.
//

import Foundation
import FoundationSwagger
import TestSwagger

extension URLSessionTask {

    private static let resumeSurrogateString = UUIDKeyString()
    private static let resumeSurrogateKey = ObjectAssociationKey(resumeSurrogateString)

    private class var resumeSurrogate: MethodSurrogate? {
        get {
            return association(for: resumeSurrogateKey) as? MethodSurrogate
        }
        set {
            guard let surrogate = newValue else {
                return removeAssociation(for: resumeSurrogateKey)
            }

            associate(surrogate, with: resumeSurrogateKey)
        }
    }

    class func beginStubbingResume() {
        guard URLSessionTask.resumeSurrogate == nil else { return }

        guard let `class` = NSClassFromString("__NSCFLocalDataTask") else {
            fatalError("Unable to use hidden data task class")
        }

        let surrogate = MethodSurrogate(
            forClass: `class`,
            ofType: .instance,
            originalSelector: #selector(URLSessionTask.resume),
            alternateSelector: #selector(URLSessionTask.stub_resume)
        )

        URLSessionTask.resumeSurrogate = surrogate
        surrogate.useAlternateImplementation()
    }

    class func endStubbingResume() {
        URLSessionTask.resumeSurrogate?.useOriginalImplementation()
        URLSessionTask.resumeSurrogate = nil
    }

    dynamic func stub_resume() {}

}
