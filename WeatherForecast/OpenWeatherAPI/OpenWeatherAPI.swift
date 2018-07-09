//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Admin on 25.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class OpenWeatherAPI {
    static func requestCurrentWeather(completion: @escaping (Weather?, Error?) -> ()) {
        let queryItems: [URLQueryItem] = constructUrlParameters()
        let baseUrlCurrentWeather = SettingsManager.sharedInstance.baseUrlCurrentWeather
        
        
        let url = baseUrlCurrentWeather.addQueryItems(queryItems).build()!
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let weather = Mapper<Weather>().map(JSONObject: value)
                completion(weather, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func requestForecastFor5Days(completion: @escaping (WeatherForecast?, Error?) -> ()) {
        let queryItems: [URLQueryItem] = constructUrlParameters()
        
        let baseUrlForecast5Days = SettingsManager.sharedInstance.baseUrlForecast5Days
        let url = baseUrlForecast5Days.addQueryItems(queryItems).build()!
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let weatherForecast = Mapper<WeatherForecast>().map(JSONObject: value) {
                    completion(weatherForecast, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private static func constructUrlParameters() -> [URLQueryItem] {
        //take parameters from Settings manager
        let cityName = SettingsManager.sharedInstance.cityName
        let languageIndex = SettingsManager.sharedInstance.languageIndex
        let units =  SettingsManager.sharedInstance.units
        let appId = SettingsManager.sharedInstance.appId
        
        var queryItems: [URLQueryItem] = []
        //append parameters to array of query items
        queryItems.append(URLQueryItem(name: "q", value: cityName))
        queryItems.append(URLQueryItem(name: "lang", value: languageIndex))
        queryItems.append(URLQueryItem(name: "units", value: units))
        queryItems.append(URLQueryItem(name: "appid", value: appId))
        return queryItems
    }
}
