//
//  CatNameCellTests.swift
//  AllisonsCatPalaceTDD
//
//  Created by Joe Susnick on 4/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import AllisonsCatPalaceTDD
import XCTest

class CatNameCellTests: XCTestCase {

    var cell: CatNameCell!
    var label: UILabel!
    var gradientLayer: CAGradientLayer!
    
    override func setUp() {
        super.setUp()
        
        let contents = Bundle(for: CatNameCell.self).loadNibNamed("CatNameCell", owner: nil, options: nil)!
        let tempCell = contents.first as! CatNameCell
        tempCell.middleColor = .purple
        label = tempCell.nameLabel // TODO: - figure out why label won't encode/decode

        let data = NSKeyedArchiver.archivedData(withRootObject: tempCell) // encodes cell
        cell = NSKeyedUnarchiver.unarchiveObject(with: data) as? CatNameCell // decodes cell which calls init(with coder)
        
        gradientLayer = cell.layer as? CAGradientLayer
    }
    
    func testNibContainsCatNameCell() {
        XCTAssertNotNil(cell,
                        "Nib must contain a cat name cell")
    }

    func testCellUsesGradientLayer() {
        XCTAssertTrue(cell.layer is CAGradientLayer,
                       "Cat name cell's layer class is a CAGradientLayer")
    }
    
    func testCellHasNameLabel() {
        guard label != nil else {
            return XCTFail("Cell should have a label for displaying a cat's name")
        }
        
        XCTAssertEqual(label.font.fontDescriptor.fontAttributes[UIFontDescriptorTextStyleAttribute] as! UIFontTextStyle, .title1,
                       "Name label should be styled with title 1")
        XCTAssertEqual(label.textAlignment, .center,
                       "Name label should be centered aligned")
        XCTAssertEqual(label.numberOfLines, 3,
                       "Name label should have maximum of three lines")
        XCTAssertEqual(label.lineBreakMode, .byTruncatingTail,
                       "Name label should truncate tail when necessary")
        
    }
    
    func testCellHasMiddleColorForGradient() {
        let plainCell = CatNameCell(style: .default, reuseIdentifier: "x") // uses the in-code initializer
        XCTAssertEqual(plainCell.middleColor, UIColor.white,
                       "Middle color should default to white when initialized in code")
        XCTAssertEqual(cell.middleColor, UIColor.purple,
                       "Middle color should be set from the serialized value")
    }
    
    func testGradientStartAndEndPoints() {
        XCTAssertEqual(gradientLayer.startPoint, CGPoint(x: 0, y: 0.5),
                       "Gradient layer should start at left-center")
        XCTAssertEqual(gradientLayer.endPoint, CGPoint(x: 1, y: 0.5),
                       "Gradient layer should end at right-center")
        XCTAssertNil(gradientLayer.locations,
                       "Gradient layer should not have locations")
    }
    
    func testGradientLayerHasThreeColors() {
        XCTAssertEqual(gradientLayer.colors?.count, 3,
                       "Gradient layer should have three colors")
    }
}
