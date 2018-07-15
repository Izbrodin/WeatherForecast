//
//  SequenceExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 13.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

extension Sequence {
    
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
