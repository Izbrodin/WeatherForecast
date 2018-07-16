//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Admin on 12.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct CurrentWeather {
    var cityName: String?
    var temperature: Temperature?
    var wind: Wind
    var conditions: String?
    var pressure: Pressure?
    var humidity: Humidity?
    var sunriseTime: String?
    var sunsetTime: String?
    var iconUrl: URL?
    var date: String?
    var dateAndTime: String?
    var time: String?
    var dateAtBeginningOfDay: Date?
    
    init(_ weather: Weather) {
        if let cityName = weather.cityName {
            self.cityName = cityName
        }
        
        if let temperature = weather.temperature {
            self.temperature = Temperature(value: temperature)
        }
        
        wind = Wind()
        if let windDegrees = weather.windDegrees {
            wind.degrees = windDegrees
        }
        
        if let windSpeed = weather.windSpeed {
            wind.speed = windSpeed
        }
        
        if let conditions = weather.conditions {
            self.conditions = conditions
        }
        
        if let pressure = weather.pressure {
            self.pressure = Pressure(value: pressure)
        }
        
        if let humidity = weather.humidity {
            self.humidity = Humidity(value: humidity)
        }
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = SettingsManager.sharedInstance.timeFormat
        
        if let sunriseTime = weather.sunriseTime {
            self.sunriseTime = CustomDateFormatter.parseDate(sunriseTime, timeFormat)
        }
        
        if let sunsetTime = weather.sunsetTime {
            self.sunsetTime = CustomDateFormatter.parseDate(sunsetTime, timeFormat)
        }
        
        if let iconName = weather.icon {
            let iconUrlString = SettingsManager.sharedInstance.apiIconBaseUrl + iconName + SettingsManager.sharedInstance.apiIconExtension
                iconUrl = URL(string: iconUrlString)
        }
        
        if let date = weather.date {
            let dateAndTimeFormatter = DateFormatter()
            dateAndTimeFormatter.dateFormat = SettingsManager.sharedInstance.dateAndTimeFormat
            dateAndTimeFormatter.locale = SettingsManager.sharedInstance.locale
            
            dateAndTime = CustomDateFormatter.parseDate(date, dateAndTimeFormatter)
            
            time = CustomDateFormatter.parseDate(date, timeFormat)
            
            dateAtBeginningOfDay = date.dateAtBeginningOfDay()!
        }
    }
}
