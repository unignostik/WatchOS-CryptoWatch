//
//  CurrencyDetailController.swift
//  CryptoWatch WatchKit Extension
//
//  Created by Chase Tillar on 12/31/17.
//  Copyright © 2017 Chase Tillar. All rights reserved.
//

import WatchKit
import SwiftyJSON

let defaults = UserDefaults(suiteName: "com.crypto.data")

class CurrencyDetailController: WKInterfaceController {

    //outlets
    @IBOutlet var currencyLabel: WKInterfaceLabel!
    @IBOutlet var currencyName: WKInterfaceLabel!
    @IBOutlet var currencyPriceUSD: WKInterfaceLabel!
    @IBOutlet var priceData: WKInterfaceLabel!
    @IBOutlet var currencyChange: WKInterfaceLabel!
    @IBOutlet var changeHr: WKInterfaceLabel!
    @IBOutlet var supplyLabel: WKInterfaceLabel!
    @IBOutlet var supplyData: WKInterfaceLabel!
    @IBOutlet var marketCapLabel: WKInterfaceLabel!
    @IBOutlet var marketCapData: WKInterfaceLabel!
    @IBOutlet var addToComplication: WKInterfaceButton!
    
    var currency = String()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        //get context
        currency = context as! String
        //set currency static labels
        currencyLabel.setText("Currency:")
        currencyName.setTextColor(UIColor.cyan)
        currencyName.setText(currency)
        currencyPriceUSD.setText("Price (USD):")
        currencyChange.setText("Hourly Change:")
        supplyLabel.setText("Total Supply:")
        marketCapLabel.setText("Market Cap (USD):")
        
        getCurrencyData(currency: currency)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK - User Instances
    
    //get currency data from CoinMarketCap api via SwiftyJSON and set data to Labels
    func getCurrencyData(currency: String) {
        
        //CoinMarketCap api
        let apiURL =  "https://api.coinmarketcap.com/v1/ticker/"+currency
        
        //create url request
        if let url = URL(string: apiURL) {
            if let data = try? String(contentsOf: url) {
                //get string rep of data
                if let dataStr = data.data(using: String.Encoding.utf8) {
                //grab and access JSON data
                let json = try? JSON(data: dataStr)
                    let price = json![0]["price_usd"].stringValue
                    let changeHrData = json![0]["percent_change_1h"].stringValue
                    let supplyTotal = json![0]["total_supply"].stringValue
                    let mrktCap = json![0]["market_cap_usd"].stringValue
                    
                    //set Labels color and data
                    priceData.setTextColor(UIColor.cyan)
                    priceData.setText("$"+price)
                    if changeHrData.first == "-" {
                        changeHr.setTextColor(UIColor.red)
                        changeHr.setText(changeHrData+"%")
                    } else {
                        changeHr.setTextColor(UIColor.green)
                        changeHr.setText("+"+changeHrData+"%")
                    }
                    supplyData.setTextColor(UIColor.cyan)
                    supplyData.setText(supplyTotal)
                    marketCapData.setTextColor(UIColor.cyan)
                    marketCapData.setText(mrktCap)
                }
            }
        }
    }
    
    //save currency data to UserDefaults
    @IBAction func addToDefaults() {
        
       print(currency)
       defaults?.set(currency, forKey: "complicationCurrency")
       defaults?.synchronize()
    }
}

