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
        indicator.style = .gray
        indicator.color = UIColor.gray

        return indicator
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(loadForecastFor5Days), for: .valueChanged)
        return refreshControl
    }()

    private var previouslyDisplayedCity: String = ""

    // Weather object index in a SectionData array
    private var weatherIndex = 0

    // Data for each table section
    private var tableData: [SectionData] = []

    private let sectionHeaderHeight: CGFloat = 98
    private let heightForFooterInSection: CGFloat = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewWeatherForeCast.rowHeight = UITableView.automaticDimension

        registerCells()

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

        tableViewWeatherForeCast.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        if previouslyDisplayedCity != SettingsManager.sharedInstance.cityName {
            //hide city name label
            self.cityNameLabel.isHidden = true
            //hide tableview until data received
            self.tableViewWeatherForeCast.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if previouslyDisplayedCity != SettingsManager.sharedInstance.cityName {
            tableData.removeAll()
            activityIndicator.startAnimating()
            loadForecastFor5Days()
        }
    }

    @objc
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
        refreshControl.endRefreshing()
    }
}

extension WeatherForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableData[section].expanded else { return 0 }
        return tableData[section].count * WeatherForecastCellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let rowNumber = indexPath.row

        let rowNumberDividedByCellTypes = Int(rowNumber / WeatherForecastCellType.allCases.count)

        weatherIndex = rowNumberDividedByCellTypes

        let weather = tableData[section][weatherIndex]
        let cellTypeIndex = rowNumber % WeatherForecastCellType.allCases.count

        switch WeatherForecastCellType.allCases[cellTypeIndex] {
        case .time:
            let cell: WeatherTimeCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateTime(from: weather)
            return cell
        case .description:
            let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: weather)
            return cell
        case .wind:
            let cell: WindTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: weather)
            return cell
        case .pressure:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updatePressure(from: weather)
            return cell
        case .humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateHumidity(from: weather)
            return cell
        }
    }
}

extension WeatherForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ExpandableHeaderView = tableView.dequeueReusableHeaderFooterView()
        let sectionTitle = tableData[section].title
        headerView.update(title: sectionTitle, section: section, delegate: self)
        return headerView
    }
}

extension WeatherForecastViewController {

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

    func constructTableViewSections(_ weatherForecast: WeatherForecastCodeable) {
        tableData = WeatherForFewDays(weatherForecast).constructDataForTable()
    }
}

extension WeatherForecastViewController: ExpandableHeaderViewDelegate {

    func toggleSection(header: ExpandableHeaderView, section: Int) {

        //change state of tapped section
        invertSectionExpandedState(section)

        let countOfRows = tableData[section].weatherList.count * WeatherForecastCellType.allCases.count
        let indexPaths = (0..<countOfRows).map { IndexPath(item: $0, section: section) }

        if tableData[section].expanded {
            tableViewWeatherForeCast.beginUpdates()
            tableViewWeatherForeCast?.insertRows(at: indexPaths, with: .fade)
            tableViewWeatherForeCast.endUpdates()
            let indexPath = IndexPath(row: 0, section: section)
            tableViewWeatherForeCast.scrollToRow(at: indexPath, at: .top, animated: false)

        } else {
            tableViewWeatherForeCast.beginUpdates()
            tableViewWeatherForeCast?.deleteRows(at: indexPaths, with: .fade)
            tableViewWeatherForeCast.endUpdates()
        }
    }
}
