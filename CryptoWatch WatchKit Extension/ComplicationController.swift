//
//  ComplicationController.swift
//  CryptoWatch WatchKit Extension
//
//  Created by Chase Tillar on 12/31/17.
//  Copyright © 2017 Chase Tillar. All rights reserved.
//

import ClockKit
import SwiftyJSON

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var currency = String()

    // MARK: - Timeline Configuration
    
    //disable TimeTravel
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        //get current currency data from api
        getComplicationData(complicationCurrency: getCurrencyForComplication())
        
        switch complication.family {
        
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider.tintColor = UIColor.cyan
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$13130.23")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Hourly: +0.12%")
            break
            
        default:
        handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func WKRefreshBackgroundTask(handler: @escaping (Date?) -> Void) {
        //update complication every 30 minutes
        handler ( Date ( timeIntervalSinceNow : TimeInterval ( 30 * 60 )))
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "BTC")
            template.line2TextProvider = CLKSimpleTextProvider(text: "+0.12%")
            
            
            break
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider.tintColor = UIColor.cyan
            template.line1TextProvider = CLKSimpleTextProvider(text: "BTC")
            template.line2TextProvider = CLKSimpleTextProvider(text: "+0.12%")
            
            break
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "BTC")
            template.line2TextProvider.tintColor = UIColor.green
            template.line2TextProvider = CLKSimpleTextProvider(text: "+0.12%")
            
            break
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider.tintColor = UIColor.cyan
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$13130.23")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Hourly: +0.12%")
            
            break
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: "BTC +012%")
            
            break
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "BTC")
            template.textProvider.tintColor = UIColor.green
            template.fillFraction = 0
            template.ringStyle = CLKComplicationRingStyle.open
            
            break
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: "BTC: $13130.23")
            break
        }
    }
    
    // MARK: - User Instances
    
    //get currency for complication
    func getCurrencyForComplication() -> String {
        
        //get and return user chosen currency for complication
        var complicationCurrency = String()
        if defaults?.value(forKey: "complicationCurrency") != nil {
            complicationCurrency = defaults?.value(forKey: "complicationCurrency") as! String
        } else {}
        return complicationCurrency
    }
    
    //get currency data from CoinMarketCap api via SwiftyJSON
    func getComplicationData(complicationCurrency: String) {
        
        //CoinMarketCap api
        let apiURL =  "https://api.coinmarketcap.com/v1/ticker/"+complicationCurrency
        
        //create url request
        if let url = URL(string: apiURL) {
            if let data = try? String(contentsOf: url) {
                //get string rep of data
                if let dataStr = data.data(using: String.Encoding.utf8) {
                    //grab and access JSON data
                    let json = try? JSON(data: dataStr)
                    let symbol = json![9]["symbol"].stringValue
                    let price = json![0]["price_usd"].stringValue
                    let changeHrData = json![0]["percent_change_1h"].stringValue
                    print(symbol)
                }
            }
        }
    }
    
} //VC End
