//
//  ArmyOfOnesTests.swift
//  ArmyOfOnesTests
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import XCTest
@testable import ArmyOfOnes

class ArmyOfOnesTests: XCTestCase {
    
    var exampleExchangeInfo:Dictionary<String,Any>?
    
    override func setUp() {
        super.setUp()
        
        let rates:NSDictionary = ["BRL":3.1181,"GBP":0.8189,"JPY":104.32,"EUR":0.91533]
        self.exampleExchangeInfo = [ "base":"USD", "date":"2016-10-26", "rates": rates]
    }
    
    func testCurrencyConverterConvertAmountIsCorrect() {
        let cc:CurrencyConverter = CurrencyConverter()
        cc.exchangeInfo = self.exampleExchangeInfo
        
        var convertedAmount:Double = cc.convertCurrency(amount: 10.0, currency: .EUR)
        XCTAssert(round(convertedAmount * 100.0) == 915)
        
        convertedAmount = cc.convertCurrency(amount: 10.0, currency: .JPY)
        XCTAssert(round(convertedAmount * 100.0) == 104320)
    }
    
    func testCurrencyConverterFetchesExchangeInfo() {
        let exchangeExpectation:XCTestExpectation = expectation(description:"exchangeInfoSet")
        
        let cc:CurrencyConverter = CurrencyConverter()
        cc.exchangeInfoCallback = {
            exchangeExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Exchange Info didn't return")
            XCTAssertNotNil(cc.exchangeInfo, "Exchange Info not set on CurrencyConverter")
            XCTAssertNotNil(cc.exchangeInfo!["rates"], "Exchange Info rates not available")
        }
        
    }
    
}
