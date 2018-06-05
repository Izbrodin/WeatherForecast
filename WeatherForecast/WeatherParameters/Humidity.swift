//
//  Humidity.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Humidity {
    var value: Double
}

extension Humidity: CustomStringConvertible {
    var description: String {
        return String(self.value) + "%"
    }
}
