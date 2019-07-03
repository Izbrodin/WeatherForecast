//
//  CellType.swift
//  WeatherForecast
//
//  Created by Admin on 06.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

enum CellType {
    case TimeUpdated
    case Description
    case Wind
    case Pressure
    case Humidity
    case Sunrise
    case Sunset
    
     static let allValues = [CellType.TimeUpdated, CellType.Description, CellType.Wind, CellType.Pressure, CellType.Humidity, CellType.Sunrise, CellType.Sunset]
}
