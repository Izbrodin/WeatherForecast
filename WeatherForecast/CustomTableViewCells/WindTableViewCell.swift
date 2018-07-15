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
    @IBOutlet weak var wLabel: UILabel!
    @IBOutlet weak var eLabel: UILabel!
    @IBOutlet weak var nLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    
    @IBOutlet private var windHeader: UILabel!
    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var speedLabel: UILabel!
    @IBOutlet private var direction: UILabel!
    @IBOutlet private var speed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        let directionAndSpeedLabelsGroup: [UILabel] = [directionLabel, speedLabel, direction, speed]
        
        windHeader.text = "Ветер"
        directionLabel.text = "Направление:"
        speedLabel.text = "Скорость:"
        
        windHeader.setFontSizeFitWidth()
        
        //set font size for wind and speed labels
        for label in directionAndSpeedLabelsGroup {
            label.setFontSizeFitWidth()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Set arrow in initial state before redrawing
        arrowImage.transform = CGAffineTransform(rotationAngle: 0)
        
        direction.text = ""
        speed.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setWindDirection(_ degrees: Double) {
        UIView.animate(withDuration: 2.0, animations: {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat((degrees * .pi) / 180))
            })
    }
    
    func update(from weather: CurrentWeather?) {
        if let degrees = weather?.wind.degrees, let direction = weather?.wind.description {
            setWindDirection(degrees)
            self.direction.text = direction
        }
        
        if let speedFormatted = weather?.wind.speedFormatted {
           self.speed.text = speedFormatted
        }
    }
}
