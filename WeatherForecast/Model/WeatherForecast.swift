//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Admin on 09.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherForecast: Mappable {
    private var nearestDaysNames: [String] = []

    var list: [Weather] = []
    
    required init?(map: Map) {
      
    }
    
    func mapping(map: Map) {
        list <- map["list"]
    }
}

