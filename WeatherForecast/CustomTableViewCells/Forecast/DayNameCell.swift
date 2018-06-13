//
//  DayNameCell.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DayNameCell: UITableViewCell {

    @IBOutlet weak private var dayName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        dayName.setFontSizeFitWidth()
        // Configure the view for the selected state
    }
    func update(name: String) {
        self.dayName.text = name
    }
    
}
