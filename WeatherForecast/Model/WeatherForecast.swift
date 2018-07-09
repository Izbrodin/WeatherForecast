//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Admin on 09.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherForecast: Mappable {
    private var nearestDaysNames: [String] = []

    var list: [Weather] = []
    
    required init?(map: Map) {
      
    }
    
    func mapping(map: Map) {
        list <- map["list"]
    }
}

extension WeatherForecast {
    func sortByDays() -> [[Weather]] {
        var weatherByDates: [[Weather]] = []
        var weatherForDate: [Weather] = []
        var currentDate: Date? = nil
        
        //sort weather list by date ascending
        list.sort(by: { $0.date?.compare($1.date!) == .orderedAscending })
        
        let calendar = SettingsManager.sharedInstance.calendar
        
        if let currDateFromAPI = list[0].date {
            currentDate = currDateFromAPI
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SettingsManager.sharedInstance.dateFormat
        dateFormatter.locale = SettingsManager.sharedInstance.locale
        dateFormatter.timeZone = SettingsManager.sharedInstance.timeZone
        
        for weather in list {
            
            if let weatherDate = weather.date {
                if !weatherDate.daysEqual(with: currentDate!) {
            
                let dayNameFormatted = CustomDateFormatter.parseDate(currentDate!, dateFormatter)
                nearestDaysNames.append(dayNameFormatted)
                
                currentDate = weather.date
                weatherByDates.append(weatherForDate)
                weatherForDate = []
                }
                
                weatherForDate.append(weather)
                
                if weather === list[list.count - 1] {
                    weatherByDates.append(weatherForDate)
                    let dayNameFormatted = CustomDateFormatter.parseDate(currentDate!, dateFormatter)
                    nearestDaysNames.append(dayNameFormatted)
                }
            }
        }
        return weatherByDates
    }
    
    func getNearestDaysNames() -> [String] {
        return nearestDaysNames
    }
}

