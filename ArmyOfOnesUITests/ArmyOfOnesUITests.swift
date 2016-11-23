//
//  ArmyOfOnesUITests.swift
//  ArmyOfOnesUITests
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import XCTest

class ArmyOfOnesUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
    }
    
    func testTextFieldExists() {
        XCTAssert(app.textFields["amountTextField"].exists)
    }
    
    func testTextFieldUpdatesCurrencyViews() {
        let amountTextField = app.textFields["amountTextField"]
        amountTextField.tap()
        
        amountTextField.typeText("9")
        let firstText:String = amountTextField.value as! String
        
        amountTextField.typeText("99")
        let secondText:String = amountTextField.value as! String
        
        XCTAssertNotNil(firstText)
        XCTAssertNotNil(secondText)
        XCTAssertTrue(firstText != secondText)
    }
    
}
