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
}
