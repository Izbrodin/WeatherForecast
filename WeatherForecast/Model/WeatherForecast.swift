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
