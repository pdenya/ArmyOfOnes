//
//  CurrencyConverter.swift
//  ArmyOfOnes
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import UIKit

class CurrencyConverter: NSObject {
    static let sharedInstance = CurrencyConverter()
    
    var exchangeInfo:Dictionary<String, Any>? {
        didSet {
            if ((self.exchangeInfoCallback) != nil) {
                print("Exchange callback")
                self.exchangeInfoCallback!()
                self.exchangeInfoCallback = nil
            }
        }
    }
    var exchangeInfoCallback:(() -> Void)?
    
    enum Currency: String {
        case USD = "USD"
        case GBP = "GBP"
        case EUR = "EUR"
        case JPY = "JPY"
        case BRL = "BRL"
    }
    
    enum CurrencySymbol: String {
        case USD = "$"
        case GBP = "£"
        case EUR = "€"
        case JPY = "¥"
        case BRL = "R$"
    }
    
    override init() {
        super.init()
        self.fetchExchangeRates()
    }
    
    func symbolForCurrency(currency:CurrencyConverter.Currency) -> CurrencyConverter.CurrencySymbol {
        var symbol:CurrencyConverter.CurrencySymbol! = CurrencyConverter.CurrencySymbol.USD
        
        switch (currency) {
            case .GBP:
                symbol = CurrencyConverter.CurrencySymbol.GBP
            case .EUR:
                symbol = CurrencyConverter.CurrencySymbol.EUR
            case .JPY:
                symbol = CurrencyConverter.CurrencySymbol.JPY
            case .BRL:
                symbol = CurrencyConverter.CurrencySymbol.BRL
            default:
                symbol = CurrencyConverter.CurrencySymbol.USD
        }
        
        return symbol
    }
    
    // converts from USD to specified currency
    func convertCurrency(amount:Double,currency:CurrencyConverter.Currency) -> Double {
        if (self.exchangeInfo != nil) {
            let rates:NSDictionary = self.exchangeInfo!["rates"] as! NSDictionary
            let rate:Double = rates.object(forKey: currency.rawValue) as! Double
            
            return rate * amount
        }
        
        return Double(0.0)
    }
    
    // fetch current exchange rates from fixer.io and store locally
    func fetchExchangeRates() {
        let url = URL(string: "http://api.fixer.io/latest?base=USD&symbols=GBP,EUR,JPY,BRL")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    self.exchangeInfo = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    print("Setting exchange info")
                    print(self.exchangeInfo)
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }).resume()
    }
}
