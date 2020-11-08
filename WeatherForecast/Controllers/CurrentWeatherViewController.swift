import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var tableViewCurrentWeather: UITableView!

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
        refreshControl.addTarget(self, action: #selector(loadCurrentWeather), for: .valueChanged)
        return refreshControl
    }()

    private var previouslyDisplayedCity: String!
    private var weather: WeatherCodable?
    private var currentWeather: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

        tableViewCurrentWeather.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        if previouslyDisplayedCity != SettingsManager.sharedInstance.cityName {
            //hide tableview until data received
            self.tableViewCurrentWeather.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if previouslyDisplayedCity != SettingsManager.sharedInstance.cityName {
            activityIndicator.startAnimating()
            loadCurrentWeather()
        }
    }

    @objc
    func loadCurrentWeather() {
        previouslyDisplayedCity = SettingsManager.sharedInstance.cityName

        OpenWeatherAPI.requestCurrentWeather(completion: {(weather, error) in
            if let weather = weather {
                self.currentWeather = CurrentWeather(weather)
                self.activityIndicator.stopAnimating()
                self.tableViewCurrentWeather.isHidden = false
                self.tableViewCurrentWeather.reloadData()
            } else if let receivedError = error {
                self.displayErrorAlert(receivedError.localizedDescription)
            } else {
                self.displayErrorAlert("Нет данных")
            }
        })
        refreshControl.endRefreshing()
    }
}

extension CurrentWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        switch CellType.allCases[rowNumber] {
        case .cityName:
            let cell: CityNameTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateCity()
            return cell
        case .timeUpdated:
            let cell: TimeUpdatedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateTime(from: currentWeather)
            return cell
        case .description:
            let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: currentWeather)
            return cell
        case .wind:
            let cell: WindTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(from: currentWeather)
            return cell
        case .pressure:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updatePressure(from: currentWeather)
            return cell
        case .humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateHumidity(from: currentWeather)
            return cell
        case .sunrise:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(parameter: .sunrise, from: currentWeather)
            return cell
        case .sunset:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(parameter: .sunset, from: currentWeather)
            return cell
        }
    }
}

extension CurrentWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CurrentWeatherViewController {

    func registerCells() {
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: TimeUpdatedTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: DescriptionTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: WindTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: ParameterTableViewCell.self)
    }
}
