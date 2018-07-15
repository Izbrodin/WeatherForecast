//
//  Wind.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Wind {
    var degrees: Double? = nil
    var speed: Double? = nil
    private let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
}

extension Wind {
    
    var speedFormatted: String {
        if let speedValue = self.speed {
            return String(speedValue) + " м/с"
        } else {
            return "no data about speed"
        }
    }
}

extension Wind: CustomStringConvertible {
    
    var description: String {
        if let degrees = self.degrees {
            let i: Int = Int((degrees + 11.25) / 22.5)
            return directions[i % 16]
        } else {
            return "no data about direction"
        }
    }
}
