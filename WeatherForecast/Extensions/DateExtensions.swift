//
//  CalendarExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

extension Date {
    
    ///Checks if dates have the same day
    func daysEqual(with date: Date) -> Bool {
        var calendar = SettingsManager.sharedInstance.calendar
        calendar.timeZone = SettingsManager.sharedInstance.timeZone
        return calendar.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    
    func dateAtBeginningOfDay() -> Date? {
        var calendar = Calendar.current
        
        calendar.timeZone = SettingsManager.sharedInstance.timeZone
        
        // Selectively convert the date components (year, month, day) of the input date
        var dateComps = calendar.dateComponents([.year, .month, .day], from: self)
        // Set the time components manually
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        
        // Convert back
        let beginningOfDay = calendar.date(from: dateComps)
        return beginningOfDay
    }
}

extension Optional: Comparable where Wrapped == Date {
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        if let l = lhs {
            if let r = rhs {
                return l < r
            } else {
                return false
            }
        } else {
            return rhs != nil
        }
    }
}
