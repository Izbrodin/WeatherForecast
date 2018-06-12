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
    var list: [Weather] = []
    
    required init?(map: Map) {
      
    }
    
    func mapping(map: Map) {
        list <- map["list"]
    }
}
