//
//  SectionData.swift
//  WeatherForecast
//
//  Created by Admin on 14.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct SectionData {
    let title: String
    let weatherList: [Weather]
    var expanded: Bool!
    
    var count: Int {
        return weatherList.count
    }
    
    subscript(index: Int) -> Weather {
        return weatherList[index]
    }
}

