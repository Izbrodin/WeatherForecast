//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController, ExpandableHeaderViewDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tableViewWeatherForeCast: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    
    var city: String!
    
    //Cell types which will be displayed in tableView
    var cellTypes = [WeatherForecastCellType.Time, WeatherForecastCellType.Description, WeatherForecastCellType.Wind, WeatherForecastCellType.Pressure, WeatherForecastCellType.Humidity]
    
    //Weather object index in a SectionData array
    var weatherIndex = 0
    var cellTypeLastIndex: Int = 0
    
    //Data for each table section
    var tableData: [SectionData] = []
    var estimatedRowHeight: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //last index of cellTypes array
        cellTypeLastIndex = cellTypes.count - 1
        
        configureRowHeight()
        
        registerCells()
        
        //set current view controller class as delegate
        tableViewWeatherForeCast.delegate = self
        //set current view controller class as datasource
        tableViewWeatherForeCast.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hide city name label
        self.cityNameLabel.isHidden = true
        //hide tableview until data received
        self.tableViewWeatherForeCast.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startActivityIndicator()
        loadForecastFor5Days()
    }
    
    func loadForecastFor5Days() {
        let languageIndex = "ru"
        let units = "metric"
        let appId = "04fe9bc8bdd23ab05caa33af5b162552"
        
        let url = URLBuilder()
            .set(scheme: "http")
            .set(host: "api.openweathermap.org")
            .set(path: "data/2.5/forecast")
            .addQueryItem(name: "q", value: self.city)
            .addQueryItem(name: "lang", value: languageIndex)
            .addQueryItem(name: "units", value: units)
            .addQueryItem(name: "appid", value: appId)
            .build()

        OpenWeatherAPI(url!).requestForecastFor5Days(completion: {(forecast, error) in
            if let receivedError = error {
                self.displayErrorAlert(receivedError.localizedDescription)
            }
            else {
            self.cityNameLabel.text = self.city
            self.constructTableViewSections(forecast)
            self.tableViewWeatherForeCast.isHidden = false
            self.cityNameLabel.isHidden = false
            self.tableViewWeatherForeCast.reloadData()
            self.stopActivityIndicator()
            }
        })
    }
}

extension WeatherForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = tableData[section].expanded ? tableData[section].count * cellTypes.count : 0
        return numberOfRowsInSection
    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let rowNumber = indexPath.row

        let rowNumberDividedByCellTypes = Int(rowNumber / cellTypes.count)

        weatherIndex = rowNumberDividedByCellTypes
        
        let weather = tableData[section][weatherIndex]
        let cellTypeIndex = rowNumber % cellTypes.count
        
        switch cellTypes[cellTypeIndex] {
            case .Time:
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(self.view.frame.size.height / 5)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableData[indexPath.section].expanded ? UITableViewAutomaticDimension : 0
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.05 * estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        let sectionTitle = tableData[section].title
        header.customInit(title: sectionTitle, section: section, delegate: self)
        return header
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        tableData[section].expanded = !tableData[section].expanded

        if tableData[section].expanded {
        tableViewWeatherForeCast.beginUpdates()
        tableViewWeatherForeCast.reloadSections(IndexSet(integer: section), with: .automatic)
        tableViewWeatherForeCast.endUpdates()
        }
        
        DispatchQueue.main.async {
            self.tableViewWeatherForeCast.reloadData()
        }
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
            let sectionData = SectionData(title: dayName, weatherList: weatherList, expanded: false)
            tableData.append(sectionData)
        }
    }
}

extension WeatherForecastViewController {
    func startActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.color = UIColor.blue
        
        DispatchQueue.main.async {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    func configureRowHeight() {
        //calculation of estimated row height
        let estimatedRowHeight = CGFloat(0.15 * Double(tableViewWeatherForeCast.bounds.height))
        //set estimated row height
        tableViewWeatherForeCast.estimatedRowHeight = estimatedRowHeight
        //set automatic dimension of row height
        tableViewWeatherForeCast.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerCells() {
        //register all types of custom cells
        tableViewWeatherForeCast.register(cellClass: WeatherTimeCell.self)
        tableViewWeatherForeCast.register(cellClass: DescriptionTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: WindTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: ParameterTableViewCell.self)
    }
}

