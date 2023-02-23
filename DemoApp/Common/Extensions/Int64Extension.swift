//
//  Int64Extension.swift
//  DemoApp
//
//  Created by srinath on 06/08/18.
//

import Foundation


extension Int64 {

    var getDateFromMilliseonds: Date {

        let date = NSDate(timeIntervalSince1970: TimeInterval(self / 1000))

        let timeZoneSeconds: TimeInterval =  TimeInterval(NSTimeZone.local.secondsFromGMT())
        date.addingTimeInterval(timeZoneSeconds)
        return date as Date
    }
    
}
