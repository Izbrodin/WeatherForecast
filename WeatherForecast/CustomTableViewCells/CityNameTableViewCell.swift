//
//  CityNameTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CityNameTableViewCell: UITableViewCell {

    @IBOutlet private var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cityName.setFontSizeFitWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityName.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCity(from weather: CurrentWeather?) {
        if let cityName = weather?.cityName {
          self.cityName.text = cityName
        }
        
    }
}
