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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        parameterLabel.text = ""
        parameterValue.text = ""
    }
    
    private func setParameterName(_ parameterName: String) {
        parameterLabel.text = parameterName
    }
    
    private func setParameterValue(_ value: String) {
        parameterValue.text = value
    }

    func updatePressure(from weather: CurrentWeather?) {
        if let description = weather?.pressure?.description {
            setParameterName("Давление:")
            setParameterValue(description)
        }
    }
  
    func updateHumidity(from weather: CurrentWeather?) {
        if let description = weather?.humidity?.description {
            setParameterName("Влажность:")
            setParameterValue(description)
        }
    }
 
    func update(parameter: SunMode, from weather: CurrentWeather?) {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = SettingsManager.sharedInstance.timeFormat
        
        switch parameter {
        case .sunrise:
            if let sunriseTime = weather?.sunriseTime {
            setParameterName("Рассвет:")
            setParameterValue(sunriseTime)
            }
        case .sunset:
            if let sunsetTime = weather?.sunsetTime {
            setParameterName("Закат:")
            setParameterValue(sunsetTime)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
