//
//  CalendarExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

extension Date {

    func dateWithoutTime() -> Date? {
        let calendar = SettingsManager.sharedInstance.calendar
              
        // Selectively convert the date components (year, month, day) of the input date
        var dateComps = calendar.dateComponents([.year, .month, .day], from: self)
        // Set the time components manually
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
       
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
