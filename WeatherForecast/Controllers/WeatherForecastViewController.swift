//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController {
    @IBOutlet weak var tableViewWeatherForeCast: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    var weatherForeCast: [Weather] = []
    let next5DaysNames = DateHelper.getNextFiveDaysNames()
    var weatherIndex = 0
    var cellTypes = [WeatherForecastCellType.DayName, WeatherForecastCellType.Description, WeatherForecastCellType.Wind, WeatherForecastCellType.Pressure, WeatherForecastCellType.Humidity]
    
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewWeatherForeCast.register(cellClass: DayNameCell.self)
        tableViewWeatherForeCast.register(cellClass: DescriptionTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: WindTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: ParameterTableViewCell.self)
        
        startActivityIndicator()
        loadForecastFor5Days()
        
        tableViewWeatherForeCast.delegate = self
        tableViewWeatherForeCast.dataSource = self
    }
    
    func loadForecastFor5Days() {
        let city = "Penza"
        let countryIndex = "ru"
        let languageIndex = "ru"
        let units = "metric"
        let appId = "04fe9bc8bdd23ab05caa33af5b162552"
        
        let url = URLBuilder()
            .set(scheme: "http")
            .set(host: "api.openweathermap.org")
            .set(path: "data/2.5/forecast")
            .addQueryItem(name: "q", value: city + "," + countryIndex)
            .addQueryItem(name: "lang", value: languageIndex)
            .addQueryItem(name: "units", value: units)
            .addQueryItem(name: "appid", value: appId)
            .build()

        OpenWeatherAPI(url!).requestForecastFor5Days(completion: {(forecast) in
            self.weatherForeCast = forecast
            self.tableViewWeatherForeCast.reloadData()
            self.stopActivityIndicator()
        })
    }
}

extension WeatherForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if weatherForeCast.count > 0 {
        let dayName = next5DaysNames[section]
        return WeatherForecast.getCountOfWeatherRecords(in: weatherForeCast, for: dayName)
        }
        else {
            return 1
        }*/
        return weatherForeCast.count
    }
 /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return next5DaysNames[section]
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        let weather = weatherForeCast[weatherIndex]
        let cellTypeIndex = rowNumber % 5
        switch cellTypes[cellTypeIndex] {
            case .DayName:
                let cell: DayNameCell = tableView.dequeueReusableCell(for: indexPath)
                
                if let dayName = weather.dateAndTime {
                    cell.update(name: dayName)
                }
                return cell
            case .Description:
                let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.update(weather: weather)
                return cell
            case .Wind:
                let cell: WindTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.update(weather: weather)
                return cell
            case .Pressure:
                let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.update(pressure: weather.pressure)
                return cell
            case .Humidity:
                let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.update(humidity: weather.humidity)
                weatherIndex = weatherIndex + 1
                return cell
            }
        return UITableViewCell()
    }
}

extension WeatherForecastViewController: UITableViewDelegate {

}

