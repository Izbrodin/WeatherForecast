//
//  City.swift
//  WeatherForecast
//
//  Created by Admin on 10.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

struct City: Mappable {
    
    var id: Int?
    var name: String?
    var country: Int?
    var longitude: Double?
    var latitude: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        country <- map["country"]
        longitude <- map["coord.lon"]
        latitude <- map["coord.lat"]
    }
}
