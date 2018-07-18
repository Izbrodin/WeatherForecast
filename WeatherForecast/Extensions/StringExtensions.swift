//
//  StringExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 18.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
