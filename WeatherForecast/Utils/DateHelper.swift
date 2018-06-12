//
//  DateHelper.swift
//  WeatherForecast
//
//  Created by Admin on 12.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func getNextFiveDaysNames() -> [String] {
    let daysRange = 0..<5
        var dates: [String] = []
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var dateComponent = DateComponents()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ru_RU")
        
        for i in daysRange {
            dateComponent.day = i
            let date = calendar.date(byAdding: dateComponent, to: currentDate)
            let dateString = formatter.string(from: date!)
            dates.append(dateString)
        }
        return dates
    }
}
