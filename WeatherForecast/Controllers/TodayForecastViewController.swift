import UIKit

import Alamofire
import SwiftyJSON
import ObjectMapper
import Kingfisher

class TodayForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewTodayForecast: UITableView!
    var weather: Weather?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 8
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 75
        }
        else if indexPath.row == 1 {
            return 75
        }
        else if indexPath.row == 2 {
            return 110
        }
        else if indexPath.row == 3 {
            return 160
        }
        else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("CityNameTableViewCell", owner: self, options: nil)?.first as! CityNameTableViewCell
            
            if let cityName = weather?.cityName {
                cell.cityName.text = cityName
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = Bundle.main.loadNibNamed("TimeUpdatedTableViewCell", owner: self, options: nil)?.first as! TimeUpdatedTableViewCell
            
            if let timeUpdated = weather?.dateAndTime {
            cell.timeUpdated.text = timeUpdated
            }
            return cell
        }
       else if indexPath.row == 2 {
            let cell = Bundle.main.loadNibNamed("DescriptionTableViewCell", owner: self, options: nil)?.first as! DescriptionTableViewCell
            
            if let iconName = weather?.icon {
                let iconUrl = "http://openweathermap.org/img/w/" + iconName + ".png"
                let url = URL(string: iconUrl)
                cell.weatherImage.kf.setImage(with: url)
            }
            if let conditions = weather?.conditions {
                cell.weatherDescription.text = conditions
            }
            if let temperature = weather?.temperature {
                cell.temperature.text = temperature.description
            }
            return cell
        }
        else if indexPath.row == 3 {
            let cell = Bundle.main.loadNibNamed("WindTableViewCell", owner: self, options: nil)?.first as! WindTableViewCell
            
            if let wind = weather?.wind {
            cell.setWindDirection(wind.degrees)
            cell.direction.text = wind.getDirection()
            cell.speed.text = wind.description
            }
            return cell
        }
        else if indexPath.row == 4 {
             let cell = Bundle.main.loadNibNamed("ParameterTableViewCell", owner: self, options: nil)?.first as!
                ParameterTableViewCell
            cell.parameterLabel.text = "Давление"
            if let pressure = weather?.pressure {
                cell.parameterValue.text = pressure.description
            }
            return cell
        }
        else {
            let cell = Bundle.main.loadNibNamed("TimeUpdatedTableViewCell", owner: self, options: nil)?.first as! TimeUpdatedTableViewCell
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*tableViewTodayForecast.register(cellClass: CityNameTableViewCell.self, forCellReuseIdentifier: "cityNameCell")*/
       
        /*
        tableViewTodayForecast.register(CityNameTableViewCell.self, forCellReuseIdentifier: "cityNameCell")
        tableViewTodayForecast.register(TimeUpdatedTableViewCell.self, forCellReuseIdentifier: "timeUpdatedTableViewCell")
        */
        
        
        
        
        
        loadTodayWeather()
        
        //self.tableViewTodayForecast = self
        
        /*let cityNameNib = UINib(nibName: "cityNameCell", bundle: nil)
        tableViewTodayForecast.register(cityNameNib, forCellReuseIdentifier: "cityNameCell")
        */

        //let weather = OpenWeatherAPI(url!).getWeather()

        tableViewTodayForecast.delegate = self
        tableViewTodayForecast.dataSource = self

    }
    
    func loadTodayWeather() {
        let city = "Penza"
        let countryIndex = "ru"
        let languageIndex = "ru"
        let units = "metric"
        let appId = "04fe9bc8bdd23ab05caa33af5b162552"
        
        /*let requestFor5Days = "http://api.openweathermap.org/data/2.5/forecast?q=Penza,ru&APPID=04fe9bc8bdd23ab05caa33af5b162552&lang=ru&units=metric"
         
         let todayWeatherRequest = "http://api.openweathermap.org/data/2.5/weather?q=Penza,ru&APPID=04fe9bc8bdd23ab05caa33af5b162552&lang=ru&units=metric"
         */
        
    
        //let weather = OpenWeatherAPI(url!).getWeather()
        
        let url = URLBuilder()
            .set(scheme: "http")
            .set(host: "api.openweathermap.org")
            .set(path: "data/2.5/weather")
            .addQueryItem(name: "q", value: city + "," + countryIndex)
            .addQueryItem(name: "lang", value: languageIndex)
            .addQueryItem(name: "units", value: units)
            .addQueryItem(name: "appid", value: appId)
            .build()
        
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                self.weather =  Mapper<Weather>().map(JSONObject: value)
                
                self.tableViewTodayForecast.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
