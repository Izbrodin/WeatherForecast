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

    func getHeight() -> CGFloat {
        switch self {
        case .CityName: return 75
        case .TimeUpdated: return 75
        case .Description: return 120
        case .Wind: return 150
        }
    }
}
