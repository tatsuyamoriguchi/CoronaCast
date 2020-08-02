//
//  Convert.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/26/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import Foundation

class Convert {

    func decimal2Percentage(numerator: Int, denominator: Int) -> String {
        
        let rateValue = Double(numerator)/Double(denominator)
        
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.minimumIntegerDigits = 1
        percentFormatter.maximumIntegerDigits = 3
        percentFormatter.maximumFractionDigits = 2
        
        guard let rateString = percentFormatter.string(from: NSNumber(value: rateValue)) else { return "Error" }
        
        return rateString
    }
    
    
    func convertDateFormatter(date: String) -> String {
        
        // 2020-07-27T07:25:28Z

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "US")
        let convertedDate = dateFormatter.date(from: date)

        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long

        let timeStamp = dateFormatter.string(from: convertedDate!)

       return timeStamp
    }
    
    
    func decimalInLocale(input: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        let output = formatter.string(from: NSNumber(value: input))!

        return output
    }

}

