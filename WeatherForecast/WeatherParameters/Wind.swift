//
//  Wind.swift
//  WeatherForecast
//
//  Created by Admin on 23.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Wind {
    let degrees: Double?
    let speed: Double?

    private enum Constants {
        static let directions = ["N",
                                 "NNE",
                                 "NE",
                                 "ENE",
                                 "E",
                                 "ESE",
                                 "SE",
                                 "SSE",
                                 "S",
                                 "SSW",
                                 "SW",
                                 "WSW",
                                 "W",
                                 "WNW",
                                 "NW",
                                 "NNW"]
        static let compassSectorLength = 22.5
        static let offsetToFixNNE = 11.25
    }
}

extension Wind {

    var speedFormatted: String {
        guard let speedValue = self.speed else {
             return "no data about speed"
        }
        return String(speedValue) + " м/с"
    }
}

extension Wind: CustomStringConvertible {
    var description: String {
        guard let degrees = self.degrees else {
            return "no data about direction"
        }
        let index = Int((degrees + Constants.offsetToFixNNE) / Constants.compassSectorLength)
        return Constants.directions[index % 16]
    }
}
