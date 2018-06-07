//
//  Weather.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable, CustomStringConvertible {
    var cityName: String?
    var dateAndTime: String?
    var temperature: Temperature?
    var conditions: String?
    var wind: Wind?
    var pressure: Pressure?
    var humidity: Humidity?
    var sunriseTime: String?
    var sunsetTime: String?
    var icon: String?

    required init?(map: Map) {

    }
    
    init?() {
        
    }

    func mapping(map: Map) {
        cityName <- map["name"]
        dateAndTime = mapDate(map["dt"])
        
        if let temperature = map["main.temp"].currentValue as? Double {
            self.temperature = Temperature(value: temperature)
        }
        
        conditions <- map["weather.0.description"]
        icon <- map["weather.0.icon"]
        
        let windDegrees = map["wind.deg"].currentValue as? Double
        let windSpeed = map["wind.speed"].currentValue as? Double
        
        wind = Wind(degrees: windDegrees!, speed: windSpeed!)
        
        if let pressureValue = map["main.pressure"].currentValue as? Double {
            pressure = Pressure(value: pressureValue)
        }
        
        if let humidityValue = map["main.humidity"].currentValue as? Double {
            humidity = Humidity(value: humidityValue)
        }
        
        sunriseTime = mapTime(map["sys.sunrise"])
        sunsetTime = mapTime(map["sys.sunset"])
    }

    fileprivate func mapDate(_ map: Map) -> String {
        return parseUTCDate(map["dt"], "E, d MMM yyyy HH:mm")
    }
    
    fileprivate func mapTime(_ map: Map) -> String {
        return parseUTCDate(map, "HH:mm")
    }
    
    fileprivate func parseUTCDate(_ map: Map,_ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ru_RU")

        if let dateTimeInterval = map.currentValue as? Double {
            let dateUTC = Date(timeIntervalSince1970: dateTimeInterval)
            return formatter.string(from: dateUTC)
        }
        else {
            return "Data wasn't retrieved"
        }
    }
    
    var description: String {
        let descr = dateAndTime! + "\n" +
            "temperature" + temperature!.description + "\n" +
            "conditions" + conditions! + "\n" +
            "wind.speed" + wind!.description + "\n" +
            "pressure" + pressure!.description + "\n" +
            "humidity" + humidity!.description + "\n" +
            "sunriseTime" + sunriseTime!  + "\n" +
            "sunsetTIme" + sunsetTime!
        return descr
    }
}
