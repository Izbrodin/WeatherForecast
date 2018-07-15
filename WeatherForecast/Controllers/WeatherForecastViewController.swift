//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Admin on 08.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tableViewWeatherForeCast: UITableView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.color = UIColor.blue
        
        return indicator
    }()
    
    private var previouslyDisplayedCity: String = ""
    
    // Cell types which will be displayed in tableView
    private let cellTypes = WeatherForecastCellType.allValues
    
    // Weather object index in a SectionData array
    private var weatherIndex = 0
    private var cellTypeLastIndex: Int = 0
    
    // Data for each table section
    private var tableData: [SectionData] = []
    
    private let estimatedRowHeight: CGFloat = 120
    private let estimatedSectionHeaderHeight: CGFloat = 98
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //last index of cellTypes array
        cellTypeLastIndex = cellTypes.count - 1
        
        configureRowHeight()
        
        registerCells()
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
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
            activityIndicator.startAnimating()
            loadForecastFor5Days()
        }
    }
    
    func loadForecastFor5Days() {
        previouslyDisplayedCity = SettingsManager.sharedInstance.cityName

        OpenWeatherAPI.requestForecastFor5Days(completion: { (forecast, error) in
            if let forecast = forecast {
                self.cityNameLabel.text = SettingsManager.sharedInstance.cityName
                self.constructTableViewSections(forecast)
                
                self.tableViewWeatherForeCast.isHidden = false
                self.cityNameLabel.isHidden = false
                self.tableViewWeatherForeCast.reloadData()
                self.activityIndicator.stopAnimating()
            } else if let receivedError = error {
                self.displayErrorAlert(receivedError.localizedDescription)
            } else {
                self.displayErrorAlert("Нет данных")
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
            cell.updateTime(from: weather)
            return cell
        case .Description:
            let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: weather)
            return cell
        case .Wind:
            let cell: WindTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: weather)
            return cell
        case .Pressure:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updatePressure(from: weather)
            return cell
        case .Humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateHumidity(from: weather)
            return cell
        }
    }
}

extension WeatherForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return estimatedSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ExpandableHeaderView = tableView.dequeueReusableHeaderFooterView()
        let sectionTitle = tableData[section].title
        headerView.update(title: sectionTitle, section: section, delegate: self)
        return headerView
    }
}

extension WeatherForecastViewController {
    
    func configureRowHeight() {
        //set estimated row height
        tableViewWeatherForeCast.estimatedRowHeight = self.estimatedRowHeight
        
        //set automatic dimension of row height
        tableViewWeatherForeCast.rowHeight = UITableViewAutomaticDimension
    }
    
    func invertSectionExpandedState(_ section: Int) {
        tableData[section].expanded = !tableData[section].expanded
    }
    
    func reloadSection(_ section: Int) {
        tableViewWeatherForeCast.beginUpdates()
        tableViewWeatherForeCast.reloadSections(IndexSet(integer: section), with: .automatic)
        tableViewWeatherForeCast.endUpdates()
    }
    
    func registerCells() {
        //register all types of custom cells
        tableViewWeatherForeCast.register(cellClass: WeatherTimeCell.self)
        tableViewWeatherForeCast.register(cellClass: DescriptionTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: WindTableViewCell.self)
        tableViewWeatherForeCast.register(cellClass: ParameterTableViewCell.self)
        tableViewWeatherForeCast.register(headerClass: ExpandableHeaderView.self)
    }
    
    func constructTableViewSections(_ weatherForecast: WeatherForecast) {
        tableData = WeatherForFewDays(weatherForecast).constructDataForTable()
    }
}

extension WeatherForecastViewController: ExpandableHeaderViewDelegate {
    
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
}

