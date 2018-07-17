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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weatherDescription.setFontSizeFitWidth()
        temperature.setFontSizeFitWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherDescription.text = nil
        temperature.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(from weather: CurrentWeather?) {
        if let url = weather?.iconUrl {
            weatherImage.kf.setImage(with: url)
        }
        
        if let conditions = weather?.conditions{
            weatherDescription.text = conditions
        }
        
        if let temperature = weather?.temperature {
            self.temperature.text = temperature.description
        }
    }
}
