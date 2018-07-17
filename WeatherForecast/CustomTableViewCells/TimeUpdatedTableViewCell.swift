//
//  TimeUpdatedTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 04.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TimeUpdatedTableViewCell: UITableViewCell {

    @IBOutlet weak private var updatedLabel: UILabel!
    @IBOutlet weak private var timeUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatedLabel.text = "Обновлено:"
        updatedLabel.setFontSizeFitWidth()
        timeUpdated.setFontSizeFitWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeUpdated.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateTime(from weather: CurrentWeather?) {
        if let dateAndTime = weather?.dateAndTime {
            timeUpdated.text = dateAndTime
        }
    }
}
