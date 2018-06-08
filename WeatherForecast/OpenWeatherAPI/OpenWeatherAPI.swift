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
    
    func request(completion: @escaping (Weather?)->()) {
        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //print(value)
                let weather = Mapper<Weather>().map(JSONObject: value)
                completion(weather)
                //let w =  Mapper<Weather>().map(JSONObject: value)
                //print("&&&&", w?.description)
            //responseJson = value
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
}
