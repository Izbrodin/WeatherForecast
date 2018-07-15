//
//  WeatherTimeCell.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WeatherTimeCell: UITableViewCell {

    @IBOutlet weak private var time: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        time.setFontSizeFitWidth()
        // Configure the view for the selected state
    }
    
    func updateTime(from weather: CurrentWeather?) {
        if let time = weather?.time {
            self.time.text = time
        }
    }
}
