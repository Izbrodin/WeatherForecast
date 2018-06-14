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

class OpenWeatherAPI{
    
    let requestUrl: String
    
    init(_ url: URL) {
       requestUrl = url.absoluteString
    }
    
    func requestCurrentWeather(completion: @escaping (Weather?)->()) {
        /*let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background, attributes: .concurrent)*/
        Alamofire.request(requestUrl, method: .get).validate().responseJSON/*(queue: backgroundQueue) */{ response in
            switch response.result {
            case .success(let value):
                let weather = Mapper<Weather>().map(JSONObject: value)
                completion(weather)
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
    
    func requestForecastFor5Days(completion: @escaping (WeatherForecast?)->()){
        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let weatherForecast = Mapper<WeatherForecast>().map(JSONObject: value) {
                    completion(weatherForecast)
                }
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
}
