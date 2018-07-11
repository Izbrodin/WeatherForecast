import UIKit
import SearchTextField
import ObjectMapper

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var mySearchTextField: SearchTextField!
    @IBOutlet weak var tableViewCurrentWeather: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    
    var previouslyDisplayedCity: String!
    var weather: Weather?
    let cellTypes = [CellType.CityName, CellType.TimeUpdated, CellType.Description, CellType.Wind, CellType.Pressure, CellType.Humidity, CellType.Sunrise, CellType.Sunset]
    var cities: [City] = []
    var citiesNames: [String?] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchTextField.isUserInteractionEnabled = false
        startActivityIndicator()
        
        //Handle item selection
        mySearchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            
            self.mySearchTextField.text = item.title
            
            if let city = self.mySearchTextField.text {
                if !city.isEmpty {
                    SettingsManager.sharedInstance.cityName = city
                    if self.previouslyDisplayedCity != SettingsManager.sharedInstance.cityName {
                        self.startActivityIndicator()
                        self.loadCurrentWeather()
                    } else {
                        self.tableViewCurrentWeather.reloadData()
                    }
                }
            }
        }

        // load cities data in a background
        DispatchQueue.global(qos: .background).async {
            if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                self.loadCitiesDataFromJson(path)
            //update UI in main thread
            DispatchQueue.main.async {
                if !self.citiesNames.isEmpty {
                    self.mySearchTextField.filterStrings(self.citiesNames as! [String])
                    self.stopActivityIndicator()
                    self.displayCitiesLoadedAlert()
                    self.mySearchTextField.isUserInteractionEnabled = true
                }
                }
            }
        }
    
        configureRowHeight()
        
        registerCells()
        
        tableViewCurrentWeather.delegate = self
        tableViewCurrentWeather.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (previouslyDisplayedCity != SettingsManager.sharedInstance.cityName) {
            //hide tableview until data received
            self.tableViewCurrentWeather.isHidden = true
        }
    }
    
    func loadCurrentWeather() {
        previouslyDisplayedCity = SettingsManager.sharedInstance.cityName
        
        OpenWeatherAPI.requestCurrentWeather(completion: {(weather, error) in
            if let receivedError = error {
                self.displayErrorAlert(receivedError.localizedDescription)
            } else {
            self.weather = weather
            self.stopActivityIndicator()
            self.tableViewCurrentWeather.isHidden = false
            self.tableViewCurrentWeather.reloadData()
            }
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
            if let date = weather?.date {
                cell.update(date: date)
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
            if let pressure = weather?.pressure {
                let pressure = Pressure(value: pressure)
                cell.update(pressure: pressure)
            }
            return cell
        case .Humidity:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let humidity = weather?.humidity {
            let humidity = Humidity(value: humidity)
            cell.update(humidity: humidity)
            }
            return cell
        case .Sunrise:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let sunriseTime = weather?.sunriseTime{
                cell.update(parameter: .sunrise, value: sunriseTime)
            }
            return cell
        case .Sunset:
            let cell: ParameterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let sunsetTime = weather?.sunsetTime {
                cell.update(parameter: .sunset, value: sunsetTime)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    func configureRowHeight() {
        let estimatedRowHeight = CGFloat(0.15 * Double(tableViewCurrentWeather.bounds.height))
        tableViewCurrentWeather.estimatedRowHeight = estimatedRowHeight
        tableViewCurrentWeather.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerCells() {
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: TimeUpdatedTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: DescriptionTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: WindTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: CityNameTableViewCell.self)
        tableViewCurrentWeather.register(cellClass: ParameterTableViewCell.self)
    }
    
    func loadCitiesDataFromJson(_ path: String) {
        var jsonResult: [[String : Any]]
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : Any]]
            
            self.cities = Mapper<City>().mapArray(JSONArray: jsonResult)
            self.citiesNames = self.cities.map{$0.name}
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func displayCitiesLoadedAlert() {
        let alertTitle = "Загрузка завершена"
        let alertMessage = "Список городов загружен"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
