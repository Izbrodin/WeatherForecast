//
//  RequestProtocol.swift
//  WeatherForecast
//
//  Created by Admin on 28.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var baseUrl: String {get}
    var appId: String {get set}
    var forecast: Forecast {get set}
    var city: String {get set}
    var country: String? {get set}
    var language: String? {get set}
    var units: String? {get set}
    var value: String {get set}
    
}
