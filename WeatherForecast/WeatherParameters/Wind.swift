//
//  Wind.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Wind {
    var degrees: Double
    var speed: Double
}

extension Wind: CustomStringConvertible {
    var description: String {
        return String(self.speed) + " м/с"
    }
    
    func getDirection() -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        
        let i: Int = Int((degrees + 11.25) / 22.5)
        return directions[i % 16]
    }
}
