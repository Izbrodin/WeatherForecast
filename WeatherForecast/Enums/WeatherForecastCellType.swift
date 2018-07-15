//
//  WeatherForecastCellType.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum WeatherForecastCellType {
    case Time
    case Description
    case Wind
    case Pressure
    case Humidity
    
    static let allValues = [WeatherForecastCellType.Time, WeatherForecastCellType.Description, WeatherForecastCellType.Wind, WeatherForecastCellType.Pressure, WeatherForecastCellType.Humidity]
}


