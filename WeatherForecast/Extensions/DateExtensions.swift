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
        
        let date1Year = calendar.component(.year, from: self)
        let date1Month = calendar.component(.month, from: self)
        let date1Day = calendar.component(.day, from: self)
        
        let date2Year = calendar.component(.year, from: date)
        let date2Month = calendar.component(.month, from: date)
        let date2Day = calendar.component(.day, from: date)
        
        return (date1Year == date2Year) && (date1Month == date2Month) && (date1Day == date2Day)
    }
}
