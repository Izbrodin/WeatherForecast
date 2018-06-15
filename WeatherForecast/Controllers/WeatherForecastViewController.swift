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
    
    //Cell types which will be displayed in tableView
    var cellTypes = [WeatherForecastCellType.DayName, WeatherForecastCellType.Description, WeatherForecastCellType.Wind, WeatherForecastCellType.Pressure, WeatherForecastCellType.Humidity]
    
    //Weather object index in a
    var weatherIndex = 0
    var cellTypeLastIndex: Int = 0
    
    //Data for each table section
    var tableData: [SectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //last index of cellTypes array
        cellTypeLastIndex = cellTypes.count - 1
        
        tableViewWeatherForeCast.register(cellClass: WeatherTimeCell.self)
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
            self.constructTableViewSections(forecast)
            self.tableViewWeatherForeCast.reloadData()
            self.stopActivityIndicator()
        })
    }
}

extension WeatherForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = tableData[section].count * cellTypes.count
        return numberOfRowsInSection
    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let rowNumber = indexPath.row
        let weather = tableData[section][weatherIndex]
        let cellTypeIndex = rowNumber % cellTypes.count
        
        if cellTypeIndex == cellTypeLastIndex {
            weatherIndex = weatherIndex + 1
        }
        
        switch cellTypes[cellTypeIndex] {
            case .DayName:
                let cell: WeatherTimeCell = tableView.dequeueReusableCell(for: indexPath)
                if let weatherTime = weather.time {
                    cell.update(time: weatherTime)
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
                return cell
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        weatherIndex = 0
    }
}

extension WeatherForecastViewController: UITableViewDelegate {

}

extension WeatherForecastViewController {
    func constructTableViewSections(_ weatherForecast: WeatherForecast?) {
        let sortedWeatherList: [[Weather]] = (weatherForecast?.sortByDays())!
        let next5DaysNames = DateHelper.getNextFiveDaysNames()
        let daysRange = 0..<cellTypes.count
        for day in daysRange {
            let dayName = next5DaysNames[day]
            let weatherList = sortedWeatherList[day]
            let sectionData = SectionData(title: dayName, weatherList: weatherList)
            tableData.append(sectionData)
        }
    }
}

extension WeatherForecastViewController {
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
}

