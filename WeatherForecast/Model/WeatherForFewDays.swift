//
//  WeatherForFewDays.swift
//  WeatherForecast
//
//  Created by Admin on 12.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class WeatherForFewDays {
    
    private var nearestDatesSortedAscending: [Date]
    private var weatherSortedByDates: [Date: [CurrentWeather]]
    
    init(_ weatherForecast: WeatherForecastCodeable) {
        var listOfWeather = weatherForecast.listOfWeather
        
        if listOfWeather.count > 0 {
            
            //exclude objects without date
            listOfWeather = listOfWeather.filter{ $0.date != nil}
            
            //sort weather by dates ascending
            listOfWeather.sort(by: { $0.date < $1.date })
            
            let listOfWeatherForFewDays: [CurrentWeather] = listOfWeather.map{ CurrentWeather($0) }
            
            //exclude objects without date
            let listOfWeatherWithDateField = listOfWeatherForFewDays.filter {
                if $0.dateWithoutTime != nil { return true
                } else {
                    return false
                }
            }
            
            //construct dictionary with weather grouped by day
            weatherSortedByDates = listOfWeatherWithDateField.group(by: { $0.dateWithoutTime! })
            
            //sort keys of a dictionary - dates ascending
            nearestDatesSortedAscending = weatherSortedByDates.keys.sorted(by: < )
        }
        else {
            nearestDatesSortedAscending = []
            weatherSortedByDates = [:]
        }
    }
    
    func constructDataForTable() -> [SectionData] {
        var tableData: [SectionData] = []
        
        if weatherSortedByDates.count > 0 {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SettingsManager.sharedInstance.dateFormat
        dateFormatter.locale = SettingsManager.sharedInstance.locale
            
        for day in nearestDatesSortedAscending {
            //Formatted date - title for section
            let title = CustomDateFormatter.parseDate(day, dateFormatter)
            
            if let weatherList = weatherSortedByDates[day] {
                    let sectionData = SectionData(title: title, weatherList: weatherList, expanded: false)
                    tableData.append(sectionData)
                }
            }
        }
        return tableData
    }
    
    func indexIsValid(day: Int) -> Bool {
        return 0...weatherSortedByDates.count ~= day
    }
 
    subscript(index: Int) -> [CurrentWeather] {
        assert(indexIsValid(day: index), "Index out of range")
        
        let day = nearestDatesSortedAscending[index]
        return weatherSortedByDates[day]!
    }
}
