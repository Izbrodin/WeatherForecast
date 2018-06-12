//
//  WeatherForecastCellType.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

enum WeatherForecastCellType {
    case DayName
    case Description
    case Wind
    case Pressure
    case Humidity
    
    func getHeight() -> CGFloat {
        switch self {
        case .DayName: return 65
        case .Description: return 120
        case .Wind: return 150
        case .Pressure: return 47
        case .Humidity: return 47
        }
    }
}


