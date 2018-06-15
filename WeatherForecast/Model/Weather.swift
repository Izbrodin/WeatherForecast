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
    var dateAndTime: String?
    var temperature: Temperature?
    var conditions: String?
    var wind: Wind?
    var pressure: Pressure?
    var humidity: Humidity?
    var sunriseTime: String?
    var sunsetTime: String?
    var icon: String?
    var date: String?
    var time: String?

    required init?(map: Map) {

    }
    
    init?() {
        
    }

    func mapping(map: Map) {
        cityName <- map["name"]
        dateAndTime = ObjectMapperDateFormatter.mapDateAndTime(map["dt"])
        
        date = ObjectMapperDateFormatter.mapDate(map["dt"])
        time = ObjectMapperDateFormatter.mapTime(map["dt"])
        
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
        
        sunriseTime =  ObjectMapperDateFormatter.mapTime(map["sys.sunrise"])
        sunsetTime = ObjectMapperDateFormatter.mapTime(map["sys.sunset"])
    }
}

extension Weather: CustomStringConvertible {
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
