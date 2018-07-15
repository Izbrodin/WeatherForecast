//
//  WeatherForFewDays.swift
//  WeatherForecast
//
//  Created by Admin on 12.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class WeatherForFewDays {
    
    private let nearestDatesSortedAscending: [Date]
    private var weatherSortedByDates: [Date: [CurrentWeather]]
    
    init(_ weatherForecast: WeatherForecast) {
        var listOfWeather = weatherForecast.list
        
        //sort weather by dates ascending
        listOfWeather.sort(by: { $0.date < $1.date })
        
        var listOfWeatherForFewDays: [CurrentWeather] = []
        
        listOfWeatherForFewDays = listOfWeather.map{ CurrentWeather($0) }
        
        weatherSortedByDates = listOfWeatherForFewDays.group(by: { $0.dateAtBeginningOfDay })
        
        nearestDatesSortedAscending = weatherSortedByDates.keys.sorted(by: < )
    }
    
    func constructDataForTable() -> [SectionData] {
        var tableData: [SectionData] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SettingsManager.sharedInstance.dateFormat
        dateFormatter.locale = SettingsManager.sharedInstance.locale
        
        for day in nearestDatesSortedAscending {
            let title = CustomDateFormatter.parseDate(day, dateFormatter)
            
            if let weatherList = weatherSortedByDates[day] {
                tableData.append(SectionData(title: title, weatherList: weatherList, expanded: false))
            }
        }
        return tableData
    }
    
    func indexIsValid(day: Int) -> Bool {
        return day >= 0 && day <= weatherSortedByDates.count
    }
 
    subscript(index: Int) -> [CurrentWeather] {
        assert(indexIsValid(day: index), "Index out of range")
        
        let day = nearestDatesSortedAscending[index]
        return weatherSortedByDates[day]!
    }
}
