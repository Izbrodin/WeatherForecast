//
//  CustomDateFormatter.swift
//  WeatherForecast
//
//  Created by Admin on 12.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjectMapperDateFormatter {
    static func mapDate(_ map: Map) -> String {
        return parseUTCDate(map, "E, d MMM yyyy")
    }
    
    static func mapDateAndTime(_ map: Map) -> String {
        return parseUTCDate(map, "E, d MMM yyyy HH:mm")
    }
    
    static func mapTime(_ map: Map) -> String {
        return parseUTCDate(map, "HH:mm")
    }
    
    static func parseUTCDate(_ map: Map, _ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let dateTimeInterval = map.currentValue as? Double {
            let dateUTC = Date(timeIntervalSince1970: dateTimeInterval)
            return formatter.string(from: dateUTC)
        }
        else {
            return "Data wasn't retrieved"
        }
    }
}
