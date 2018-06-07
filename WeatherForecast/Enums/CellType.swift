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
    case CityName
    case TimeUpdated
    case Description
    case Wind
    case Pressure
    case Humidity
    case Sunrise
    case Sunset

    func getHeight() -> CGFloat {
        switch self {
        case .CityName: return 75
        case .TimeUpdated: return 75
        case .Description: return 100
        case .Wind: return 150
        case .Pressure: return 70
        case .Humidity: return 70
        case .Sunrise: return 70
        case .Sunset: return 70
        }
    }
}
