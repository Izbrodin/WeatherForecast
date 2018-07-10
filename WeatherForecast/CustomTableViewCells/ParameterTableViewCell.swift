//
//  ParameterTableViewCell.swiftif
//  WeatherForecast
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ParameterTableViewCell: UITableViewCell {

    @IBOutlet var parameterLabel: UILabel!
    @IBOutlet var parameterValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        parameterLabel.setFontSizeFitWidth()
        parameterValue.setFontSizeFitWidth()
    }

    func update(pressure: Pressure?) {
        if let description = pressure?.description {
            setParameterName("Давление:")
            setParameterValue(description)
        }
    }
  
    func update(humidity: Humidity?) {
        if let description = humidity?.description {
            setParameterName("Влажность:")
            setParameterValue(description)
        }
    }
 
    func update(parameter: SunMode, value time: Date) {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = SettingsManager.sharedInstance.timeFormat
        
        switch parameter {
        case .sunrise:
             setParameterName("Рассвет:")
                
             let sunriseTimeFormatted = CustomDateFormatter.parseDate(time, timeFormat)
             setParameterValue(sunriseTimeFormatted)
        case .sunset:
                setParameterName("Закат:")
        
                let sunsetTimeFormatted = CustomDateFormatter.parseDate(time, timeFormat)
                setParameterValue(sunsetTimeFormatted)
        }
    }
    
    private func setParameterName(_ parameterName: String) {
        parameterLabel.text = parameterName
    }
        
    private func setParameterValue(_ value: String) {
        parameterValue.text = value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
