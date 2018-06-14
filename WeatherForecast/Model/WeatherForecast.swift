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
    
    static func getCountOfWeatherRecords(in listOfWeather: [Weather], for date: String) -> Int {
        var count = 0
        for weather in listOfWeather {
            if weather.date == date {
                count = count + 1
            }
        }
        return count
    }
}

extension WeatherForecast {
    func sortByDays() -> [[Weather]] {
        var weatherByDates: [[Weather]] = []
        var weatherForDate: [Weather] = []
        var currentDate = list[0].date
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

