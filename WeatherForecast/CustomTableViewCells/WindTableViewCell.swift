//
//  WindTableViewCell.swift
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WindTableViewCell: UITableViewCell {
    
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var windHeader: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var direction: UILabel!
    @IBOutlet var speed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        windHeader.text = "Ветер"
        
        directionLabel.text = "Направление"
        speedLabel.text = "Скорость"    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setWindDirection(_ degrees: Double) {
        //let radian = degrees * M_PI / 180
        //arrowImage.transform = arrowImage.transform.rotated(by: CGFloat(M_PI_2))
        arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat((degrees * .pi) / 180))
        //
        //arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 3/2)
        //arrowImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
}
