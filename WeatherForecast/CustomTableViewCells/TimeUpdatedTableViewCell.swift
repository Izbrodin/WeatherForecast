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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = SettingsManager.sharedInstance.dateAndTimeFormat
        formatter.locale = SettingsManager.sharedInstance.locale
        timeUpdated.text = formatter.string(from: date)
    }
}
