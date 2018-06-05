//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Admin on 05.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Temperature {
    var value: Double
}

extension Temperature: CustomStringConvertible {
    var description: String {
        return String(self.value) + "˚C"
    }
}
