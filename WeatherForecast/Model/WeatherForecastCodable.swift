//
//  WeatherForecastCodable.swift
//  WeatherForecast
//
//  Created by Admin on 19.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct WeatherForecastCodeable: Decodable {
    var listOfWeather: [WeatherCodable] = []

    private enum CodingKeys: String, CodingKey {
        case list
    }
}

extension WeatherForecastCodeable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        listOfWeather = try container.decode([WeatherCodable].self, forKey: .list)
    }
}
