//
//  DateExtension.swift
//  DemoApp
//
//  Created by Muhameed Shabeer on 03/08/18.
//

import Foundation


extension Date {
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy HH:mm:ss"
        return dateFormatter.string(from:self)
    }

    func numberOfDaysToExpire() -> String {
        
        let dayHourMinute: Set<Calendar.Component> = [.day, .hour, .minute]
        let difference = NSCalendar.current.dateComponents(dayHourMinute, from: Date(), to: self);
        
        if let day = difference.day, day          > 0 { return "Expires in " + String(day) + " Days" }
        if let hour = difference.hour, hour       > 0 { return "Expires in " + String(hour) + " Hours" }
        if let minute = difference.minute, minute > 0 { return "Expires in " + String(minute) + " Minutes" }
        return "Expired"
    }
}
