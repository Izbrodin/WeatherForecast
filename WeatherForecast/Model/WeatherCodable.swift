//
//  WeatherCodable.swift
//  WeatherForecast
//
//  Created by Admin on 18.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct WeatherCodeable: Decodable {
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
    
     enum CodingKeys: String, CodingKey {
        case weather, mainParameters = "main", wind, date = "dt", systemInfo = "sys"
        
        enum WeatherParameters: String, CodingKey {
            case description, icon
        }
        
        enum MainParameters: String, CodingKey {
            case temperature = "temp", pressure, humidity
        }
        
        enum WindParameters: String, CodingKey {
            case speed, degrees = "deg"
        }
        
        enum SystemParameters: String, CodingKey {
            case sunrise, sunset
        }
    }
}

extension WeatherCodeable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var weather = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherParameters = try weather.nestedContainer(keyedBy: CodingKeys.WeatherParameters.self)

        let main = try container.nestedContainer(keyedBy: CodingKeys.MainParameters.self, forKey: .mainParameters)
        
        let wind = try container.nestedContainer(keyedBy: CodingKeys.WindParameters.self, forKey: .wind)
        
        let systemInfo = try container.nestedContainer(keyedBy: CodingKeys.SystemParameters.self, forKey: .systemInfo)

        self.temperature = try? main.decode(Double.self, forKey: .temperature)
        self.conditions = try? weatherParameters.decode(String.self, forKey: .description)
        self.windDegrees = try? wind.decode(Double.self, forKey: .degrees)
        self.windSpeed = try? wind.decode(Double.self, forKey: .speed)
        self.pressure = try? main.decode(Double.self, forKey: .pressure)
        self.humidity = try? main.decode(Double.self, forKey: .humidity)
        self.sunriseTime = try? systemInfo.decode(Date.self, forKey: .sunrise)
        self.sunsetTime = try? systemInfo.decode(Date.self, forKey: .sunset)
        
        self.icon = try? weatherParameters.decode(String.self, forKey: .icon)
        self.date = try? container.decode(Date.self, forKey: .date)
    }
}
