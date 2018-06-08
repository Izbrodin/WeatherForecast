//
//  WindTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WindTableViewCell: UITableViewCell {
    
    @IBOutlet private var arrowImage: UIImageView!
    @IBOutlet private var windHeader: UILabel!
    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var speedLabel: UILabel!
    @IBOutlet private var direction: UILabel!
    @IBOutlet private var speed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        windHeader.text = "Ветер"
        
        directionLabel.text = "Направление:"
        speedLabel.text = "Скорость:"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setWindDirection(_ degrees: Double) {
        arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat((degrees * .pi) / 180))
    }
    
    func update(weather: Weather?) {
        if let wind = weather?.wind {
            setWindDirection(wind.degrees)
            direction.text = wind.getDirection()
            speed.text = wind.description
        }
    }
}
