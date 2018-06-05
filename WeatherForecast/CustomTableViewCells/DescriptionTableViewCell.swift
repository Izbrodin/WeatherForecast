//
//  DescriptionTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet var weatherImage: UIImageView!
    
    @IBOutlet var weatherDescription: UILabel!
    
    @IBOutlet weak var temperature: UILabel!

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
    
}
