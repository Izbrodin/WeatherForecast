//
//  Weather.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable {
    var cityName: String?
    var temperature: Double?
    var conditions: String?
    var windDegrees: Double?
    var windSpeed: Double?
    var pressure: Double?
    var humidity: Double?
    var sunriseTime: Date?
    var sunsetTime: Date?
    var icon: String?
    var date: Date?

    required init?(map: Map) {

    }
    
    init?() {
        
    }

    func mapping(map: Map) {
        cityName <- map["name"]
        date <- (map["dt"], DateTransform())
        temperature <- map["main.temp"]
        conditions <- map["weather.0.description"]
        icon <- map["weather.0.icon"]
        windDegrees <- map["wind.deg"]
        windSpeed <- map["wind.speed"]
        pressure <- map["main.pressure"]
        humidity <- map["main.humidity"]
        sunriseTime <- (map["sys.sunrise"], DateTransform())
        sunsetTime <- (map["sys.sunset"], DateTransform())
    }
}

extension Weather: CustomStringConvertible {
    var description: String {
        var properties: [String: String] = [:]
        
        if let temperature = temperature {
        properties["temperature"] = Temperature(value: temperature).description
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = SettingsManager.sharedInstance.dateAndTimeFormat
        formatter.locale = SettingsManager.sharedInstance.locale
        
        if let date = date {
        properties["dateAndTime"] = CustomDateFormatter.parseDate(date, formatter)
        }
        if let conditions = conditions {
        properties["conditions"] = conditions
        }
        
        if let windSpeed = windSpeed {
        properties["wind.speed"] = String(windSpeed)
        }
            
        if let pressure = pressure {
        properties["pressure"] = String(pressure)
        }
            
        if let humidity = humidity {
        properties["humidity"] = String(humidity)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SettingsManager.sharedInstance.timeFormat
        
        if let sunriseTime = sunriseTime {
            properties["sunriseTime"] = CustomDateFormatter.parseDate(sunriseTime, dateFormatter)
        }
        if let sunsetTime = sunsetTime {
            properties["sunsetTIme"] = CustomDateFormatter.parseDate(sunsetTime, dateFormatter)
        }
        
        var propertiesString = ""
            
        for (propertyName, propertyValue) in properties {
            let string = propertyName + ": " + propertyValue + "\n"
            propertiesString.append(string)
        }
        return propertiesString
    }
}
