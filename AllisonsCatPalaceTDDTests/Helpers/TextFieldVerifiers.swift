//
//  TextFieldVerifiers.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 8/15/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import XCTest

extension XCTestCase {
    func verifyTextFieldIsEmpty(
        _ textField: UITextField,
        _ message: String,
        inFile file: String = #file,
        atLine line: UInt = #line
        ) {

        let valid: Bool

        if let text = textField.text {
            valid = text.isEmpty
        }
        else {
            valid = true
        }

        if !valid {
            recordFailure(
                withDescription: message,
                inFile: file,
                atLine: Int(line),
                expected: true
            )
        }
    }
}
