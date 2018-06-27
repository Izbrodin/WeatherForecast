import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var tableViewCurrentWeather: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    
    var city: String!
    var weather: Weather?
    var cellTypes = [CellType.CityName, CellType.TimeUpdated, CellType.Description, CellType.Wind, CellType.Pressure, CellType.Humidity, CellType.Sunrise, CellType.Sunset]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let estimatedRowHeight = CGFloat(0.15 * Double(tableViewCurrentWeather.bounds.height))
        tableViewCurrentWeather.estimatedRowHeight = estimatedRowHeight
        tableViewCurrentWeather.rowHeight = UITableViewAutomaticDimension
        
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: TimeUpdatedTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: DescriptionTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: WindTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: ParameterTableViewCell.self)
        
        tableViewCurrentWeather.delegate = self
        tableViewCurrentWeather.dataSource = self
        
        startActivityIndicator()
        loadCurrentWeather()
    }
    
    func loadCurrentWeather() {
        let languageIndex = "ru"
        let units = "metric"
        let appId = "04fe9bc8bdd23ab05caa33af5b162552"
        
        let url = URLBuilder()
            .set(scheme: "http")
            .set(host: "api.openweathermap.org")
            .set(path: "data/2.5/weather")
            .addQueryItem(name: "q", value: self.city)
            .addQueryItem(name: "lang", value: languageIndex)
            .addQueryItem(name: "units", value: units)
            .addQueryItem(name: "appid", value: appId)
            .build()
        
        OpenWeatherAPI(url!).requestCurrentWeather(completion: {(weather) in
            self.weather = weather
            self.stopActivityIndicator()
            self.tableViewCurrentWeather.reloadData()
        })
    }
}

extension CurrentWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        switch cellTypes[rowNumber] {
        case .CityName:
            let cell: CityNameTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let city = weather?.cityName {
            cell.updateCity(name: city)
            }
            return cell
        case .TimeUpdated:
            let cell: TimeUpdatedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let timeUpdated = weather?.dateAndTime {
                cell.update(dateAndTime: timeUpdated)
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
            cell.update(pressure: weather?.pressure)
            return cell
        case .Humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(humidity: weather?.humidity)
            return cell
        case .Sunrise:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(parameter: .sunrise, from: weather)
            return cell
        case .Sunset:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(parameter: .sunset, from: weather)
            return cell
        }
        return UITableViewCell()
    }
}

extension CurrentWeatherViewController: UITableViewDelegate {
 
}

extension CurrentWeatherViewController {
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
}
