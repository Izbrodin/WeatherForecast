//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Admin on 25.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherAPI {

    static func requestCurrentWeather(completion: @escaping (WeatherCodeable?, Error?) -> Void) {
        let queryItems: [URLQueryItem] = constructUrlParameters()
        let baseUrlCurrentWeather = SettingsManager.sharedInstance.baseUrlCurrentWeather
        let url = baseUrlCurrentWeather.addQueryItems(queryItems).build()!

        AF.request(url, method: .get).validate()
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let codableWeather = try? decoder.decode(WeatherCodeable.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(codableWeather, nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    static func requestForecastFor5Days(completion: @escaping (WeatherForecastCodeable?, Error?) -> Void) {
        let queryItems: [URLQueryItem] = constructUrlParameters()
        let baseUrlForecast5Days = SettingsManager.sharedInstance.baseUrlForecast5Days
        let url = baseUrlForecast5Days.addQueryItems(queryItems).build()!

        AF.request(url, method: .get).validate()
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherForecastCodable = try? decoder.decode(WeatherForecastCodeable.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(weatherForecastCodable, nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    private static func constructUrlParameters() -> [URLQueryItem] {
        //take parameters from Settings manager
        let cityName = SettingsManager.sharedInstance.cityName
        let languageIndex = SettingsManager.sharedInstance.languageIndex
        let units =  SettingsManager.sharedInstance.units
        let appId = SettingsManager.sharedInstance.appId

        //construct array of query parameters
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: cityName))
        queryItems.append(URLQueryItem(name: "lang", value: languageIndex))
        queryItems.append(URLQueryItem(name: "units", value: units))
        queryItems.append(URLQueryItem(name: "appid", value: appId))
        return queryItems
    }
}
