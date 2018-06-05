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
        print(requestUrl)
    }
    
    func getWeather() -> Weather? {
        var responseJson: Any?
        var weath: Weather?
        
        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //print(value)
                weath = Mapper<Weather>().map(JSONObject: value)!
                //let w =  Mapper<Weather>().map(JSONObject: value)
                //print("&&&&", w?.description)
                //responseJson = value
            case .failure(let error):
                print(error)
            }
        }
        
        //let weather = Mapper<Weather>().map(JSONObject: responseJson)
        
        //print("----", weather?.temperature)
      
        return Mapper<Weather>().map(JSONObject: responseJson)
    }
}
