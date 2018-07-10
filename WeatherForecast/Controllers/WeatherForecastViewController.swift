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
    
    var previouslyDisplayedCity: String!
    
    //Cell types which will be displayed in tableView
    let cellTypes = [WeatherForecastCellType.Time, WeatherForecastCellType.Description, WeatherForecastCellType.Wind, WeatherForecastCellType.Pressure, WeatherForecastCellType.Humidity]
    
    //Weather object index in a SectionData array
    var weatherIndex = 0
    var cellTypeLastIndex: Int = 0
    
    //Data for each table section
    var tableData: [SectionData] = []
    var estimatedRowHeight: CGFloat = 120
    var estimatedSectionHeaderHeight: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //last index of cellTypes array
        cellTypeLastIndex = cellTypes.count - 1
        
        configureRowHeight()
        configureSectionHeaderHeight()
        
        registerCells()
        
        //set current view controller class as delegate
        tableViewWeatherForeCast.delegate = self
        //set current view controller class as datasource
        tableViewWeatherForeCast.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (previouslyDisplayedCity != SettingsManager.sharedInstance.cityName) {
            //hide city name label
            self.cityNameLabel.isHidden = true
            //hide tableview until data received
            self.tableViewWeatherForeCast.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (previouslyDisplayedCity != SettingsManager.sharedInstance.cityName) {
            tableData.removeAll()
            startActivityIndicator()
            loadForecastFor5Days()
        } else {
            tableViewWeatherForeCast.reloadData()
        }
    }
    
    func loadForecastFor5Days() {
        previouslyDisplayedCity = SettingsManager.sharedInstance.cityName

        OpenWeatherAPI.requestForecastFor5Days(completion: {(forecast, error) in
            if let receivedError = error {
                self.displayErrorAlert(receivedError.localizedDescription)
            } else {
                self.cityNameLabel.text = SettingsManager.sharedInstance.cityName
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
            if let weatherTime = weather.date {
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
            if let pressureValue = weather.pressure {
                let pressure = Pressure(value: pressureValue)
                cell.update(pressure: pressure)
            }
            return cell
        case .Humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let humidityValue = weather.humidity {
                 let humidity = Humidity(value: humidityValue)
                cell.update(humidity: humidity)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return estimatedSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.05 * estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ExpandableHeaderView = tableView.dequeueReusableHeaderFooterView()
            let sectionTitle = tableData[section].title
            headerView.customInit(title: sectionTitle, section: section, delegate: self)
            return headerView
        }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        //change state of currently expanded sections and hide them
        let sectionsCount = tableData.count

        invertSectionExpandedState(section)

        if tableData[section].expanded {
    
        //scroll first row of section at the top
        DispatchQueue.main.async {
            self.reloadSection(section)
            let indexPath = IndexPath(row: 0, section: section)
            self.tableViewWeatherForeCast.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            DispatchQueue.main.async {
                self.tableViewWeatherForeCast.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            for i in 0..<sectionsCount {
                if self.tableData[i].expanded && i != section {
                    self.invertSectionExpandedState(i)
                    self.reloadSection(i)
                }
            }
            self.tableViewWeatherForeCast.reloadData()
        }
    }
    
    func invertSectionExpandedState(_ section: Int) {
        tableData[section].expanded = !tableData[section].expanded
    }
    
    func reloadSection(_ section: Int) {
        tableViewWeatherForeCast.beginUpdates()
        tableViewWeatherForeCast.reloadSections(IndexSet(integer: section), with: .automatic)
        tableViewWeatherForeCast.endUpdates()
    }
}

extension WeatherForecastViewController: UITableViewDelegate {

}

extension WeatherForecastViewController {
    func constructTableViewSections(_ weatherForecast: WeatherForecast?) {
        let sortedWeatherList: [[Weather]] = (weatherForecast?.sortByDays())!
    
        if let nearestDaysNames = weatherForecast?.getNearestDaysNames() {
        let daysRange = 0..<nearestDaysNames.count
        for day in daysRange {
            let dayName = nearestDaysNames[day]
            let weatherList = sortedWeatherList[day]
            let sectionData = SectionData(title: dayName, weatherList: weatherList, expanded: false)
            tableData.append(sectionData)
            }
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
    
    func configureSectionHeaderHeight() {
        estimatedSectionHeaderHeight = CGFloat(0.16 * Double(tableViewWeatherForeCast.bounds.height))
    }
    
    func registerCells() {
        //register all types of custom cells
        tableViewWeatherForeCast.register(cellClass: WeatherTimeCell.self)
        tableViewWeatherForeCast.register(cellClass: DescriptionTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: WindTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: ParameterTableViewCell.self)
        tableViewWeatherForeCast.register(headerClass: ExpandableHeaderView.self)
    }
}

