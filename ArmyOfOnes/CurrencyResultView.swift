//
//  CurrencyResultView.swift
//  ArmyOfOnes
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import UIKit

class CurrencyResultView: UIView {
    
    var currencyLabel:UILabel!
    var amountLabel:UILabel!
    
    var amount:Double? {
        didSet {
            self.updateLabels()
        }
    }
    
    var currency:CurrencyConverter.Currency? {
        didSet {
            self.updateLabels()
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor = UIColor.HugeMagentaColor
        
        let blocksize:CGFloat = frame.size.width
        
        // big 3 letter currency label
        currencyLabel = UILabel(frame:CGRect(x:0,y:50,width:blocksize,height:60))
        currencyLabel.textAlignment = .center
        currencyLabel.textColor = UIColor.white
        currencyLabel.font = UIFont(name: "HUGE-AvantGarde-Bold", size: 55)
        currencyLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        self.addSubview(currencyLabel)
        
        // smaller #s label
        amountLabel = UILabel(frame:CGRect(x:5.0,y:(blocksize/1.8),width:blocksize-10.0,height:60))
        amountLabel.font = UIFont(name: "Copernicus-BookItalic", size: 17)
        amountLabel.numberOfLines = 2
        amountLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        amountLabel.textAlignment = .center
        amountLabel.textColor = UIColor.white
        amountLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        self.addSubview(amountLabel)
        
        // making sure these aren't blank but they'll be set by the view's owner
        amount = 0.00
        currency = CurrencyConverter.Currency.USD
        
        amountLabel?.text = "Loading..."
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func updateLabels() {
        if (currency != nil) {
            currencyLabel.text = "\(currency!)"
        }
        
        if (amount != nil && currency != nil && CurrencyConverter.sharedInstance.exchangeInfo != nil) {
            // setup number formatter
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = CurrencyConverter.sharedInstance.symbolForCurrency(currency: currency!).rawValue
            
            // convert amount with number formatter
            let amountString:String = formatter.string(from:NSNumber(value: amount!))!
            
            // set label text
            amountLabel.text = amountString
        }
    }
    
    func convertAndSetAmount(_ newAmount:Double) {
        let converted:Double = CurrencyConverter.sharedInstance.convertCurrency(amount:newAmount, currency:currency!)
        self.amount = converted
    }
}
