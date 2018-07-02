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
        var currentDate: String? = nil
        
        if let currDateFromAPI = list[0].date {
            currentDate = currDateFromAPI
        }
        
        for weather in list {
            if weather.date != currentDate {
                currentDate = weather.date
                weatherByDates.append(weatherForDate)
                weatherForDate = []
            }
            weatherForDate.append(weather)
        }
        return weatherByDates
    }
}

