//
//  Pressure.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Pressure {
    var value: Double
}

extension Pressure: CustomStringConvertible {
    var description: String {
        return String(self.value) + "мм рт.ст"
    }
}
