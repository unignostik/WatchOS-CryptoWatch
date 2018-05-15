//
//  InterfaceController.swift
//  CryptoWatch WatchKit Extension
//
//  Created by Chase Tillar on 12/31/17.
//  Copyright © 2017 Chase Tillar. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    //outlets
    @IBOutlet var currencyTable: WKInterfaceTable!
    
    //variables
    let currencies = ["Bitcoin", "Ripple", "Ethereum", "Bitcoin-cash", "Litecoin", "Iota", "Nem"]
    var selectedCurrency = String()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        setTable()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK - InterfaceTable Datasource
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedCurrency = currencies[rowIndex]
        pushController(withName: "CurrencyDetailController", context: selectedCurrency)
    }
    
    func setTable()  {
        currencyTable.setNumberOfRows(currencies.count, withRowType: "currencies")
        for (index, currency) in currencies.enumerated() {
            let row = currencyTable.rowController(at: index) as! CurrencyLabelController
            row.currencyLabel.setText(currency)
        }
    }
}
