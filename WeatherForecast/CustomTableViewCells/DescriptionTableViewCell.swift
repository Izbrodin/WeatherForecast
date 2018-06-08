//
//  DescriptionTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet private var weatherImage: UIImageView!
    
    @IBOutlet private var weatherDescription: UILabel!
    
    @IBOutlet private weak var temperature: UILabel!

    private let apiIconPath = "http://openweathermap.org/img/w/"
    
    private let iconExtension = ".png"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weatherDescription.adjustsFontSizeToFitWidth = true
        temperature.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(weather: Weather?) {
        if let iconName = weather?.icon {
            let iconUrl = apiIconPath + iconName + iconExtension
            let url = URL(string: iconUrl)
            weatherImage.kf.setImage(with: url)
        }
        
        if let conditions = weather?.conditions{
            weatherDescription.text = conditions
        }
        
        if let temperatureValue = weather?.temperature?.description{
            temperature.text = temperatureValue
        }
    }
    
}
