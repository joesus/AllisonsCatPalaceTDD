//
//  GestureRecognizerHelper.swift
//  AllisonsCatPalaceTDDTests
//
//  Created by Joe Susnick on 11/23/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIGestureRecognizer {

    var targetedActions: [(target: Any, action: Selector)] {
        guard let targetActionPairs = value(forKey: "_targets") as? [AnyObject] else {
            fatalError("Unable to extract target/action references from gesture recognizer type")
        }

        return targetActionPairs.flatMap { pair in
            guard let target = pair.value(forKey: "_target"),
                let action = pair.description?.extractActionSelector()
                else {
                    return nil
            }

            return (target: target, action: action)
        }
    }

}

private extension String {

    func extractActionSelector() -> Selector? {
        guard let selectorString = trimmingCharacters(in: CharacterSet(charactersIn: "()"))
            .components(separatedBy: ", ")
            .map({ $0.components(separatedBy: "=") })
            .first(where: { $0.first ?? "" == "action" })?
            .dropFirst()
            .first
            else {
                return nil
        }

        return NSSelectorFromString(selectorString)
    }

}
