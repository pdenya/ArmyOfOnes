//
//  ViewController.swift
//  ArmyOfOnes
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField?
    var displayCurrencies:Array<CurrencyConverter.Currency>?
    var currencyViews:Array<CurrencyResultView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // brand background
        self.view.backgroundColor = UIColor.black
        
        // label setup
        amountField?.font = UIFont(name: "HUGE-AvantGarde-Bold", size: 50)
        amountField?.delegate = self
        amountField?.addTarget(self, action: #selector(ViewController.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        
        // currency results to display
        displayCurrencies = [
            CurrencyConverter.Currency.BRL,
            CurrencyConverter.Currency.EUR,
            CurrencyConverter.Currency.GBP,
            CurrencyConverter.Currency.JPY
        ]
        
        // create a display block for each currency
        let currencyBlockOffset:CGFloat = (self.amountField?.bottomEdge())! + 8
        
        // build display views for currency conversions
        currencyViews = []
        
        for (index, currency) in (displayCurrencies?.enumerated())! {
            let halfWidth:CGFloat = round(self.view.frame.size.width/2)
            let blockSize:CGFloat = halfWidth - 12
            
            // tile frames
            let blockframe:CGRect = CGRect(
                x: ((index % 2 == 0) ? 8 : halfWidth + 4), // 8 is the gutter size
                y: ((blockSize + 8) * floor(CGFloat(index) / 2.0)) + currencyBlockOffset,
                width: blockSize,
                height: blockSize
            )
            
            let currencyBlock:CurrencyResultView = CurrencyResultView(frame: blockframe)
            currencyBlock.currency = currency
            
            self.view.addSubview(currencyBlock)
            currencyViews?.append(currencyBlock)
        }
        
        // update amounts
        let cc:CurrencyConverter = CurrencyConverter.sharedInstance
        if (cc.exchangeInfo != nil) {
            // exchange info exists, update now
            self.updateAmounts()
        } else {
            // update immediately after fetching exchangeInfo
            cc.exchangeInfoCallback = {
                DispatchQueue.main.async {
                    self.updateAmounts()
                }
            }
        }
        
        // keyboard handling
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func updateAmounts() {
        var usdAmount:Double? = Double((amountField?.text)!)
        
        if (usdAmount == nil) {
            usdAmount = Double(0.0)
        }
        
        for currencyView:CurrencyResultView in currencyViews! {
            currencyView.convertAndSetAmount(usdAmount!)
        }
    }
    

}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChange(sender:Any) {
        self.updateAmounts()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func keyboardDidShow(notification: NSNotification) -> Void {
        NSLog("keyboard shown!")
        
        // get keyboard frame
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame = value.cgRectValue
        let keyboardFrame = self.view.convert(rawFrame!, from: nil)
        
        // calculate block height based on space between search field and keyboard
        // these 8s are the gutter padding
        let heightAvailable:CGFloat = keyboardFrame.origin.y - (amountField?.bottomEdge())! - 8.0
        let rows:CGFloat = CGFloat((currencyViews?.count)! / 2)
        let blockHeight:CGFloat = round(heightAvailable / rows) - 8.0
        
        // the blocks to fit
        UIView.animate(withDuration: 0.4) {
            for (index, currencyView) in self.currencyViews!.enumerated() {
                currencyView.setHeight(blockHeight)
                
                // if we're on at least the 2nd row then reposition to right below the previous row
                if (index > 1) {
                    currencyView.setY(self.currencyViews![index - 2].bottomEdge() + 8.0)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        // animate blocks back to squares
        let blockHeight:CGFloat = self.currencyViews![0].frame.size.width
        
        UIView.animate(withDuration: 0.4) {
            for (index, currencyView) in self.currencyViews!.enumerated() {
                currencyView.setHeight(blockHeight)
                
                // if we're on at least the 2nd row then reposition to right below the previous row
                if (index > 1) {
                    currencyView.setY(self.currencyViews![index - 2].bottomEdge() + 8.0)
                }
            }
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

