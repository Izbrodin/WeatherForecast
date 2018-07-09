//
//  UILabelExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 13.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setFontSizeFitWidth() {
        self.minimumScaleFactor = 0.5
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 1
    }
}

