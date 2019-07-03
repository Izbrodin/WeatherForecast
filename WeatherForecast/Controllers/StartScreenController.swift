//
//  StartScreenController.swift
//  WeatherForecast
//
//  Created by Admin on 25.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import JKBottomSearchView

class StartScreenController: UIViewController {
    private let locationManager = CLLocationManager()
    private let searchView = JKBottomSearchView()
    let placeMarkerImage = #imageLiteral(resourceName: "placeMarker")
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск местоположения"
        configureLocationManager()
        mapView.showsUserLocation = true
        
        searchView
            .tableView.register(cellClass: PlaceTableViewCell.self)
        searchView.dataSource = self
        searchView.delegate = self
        searchView.placeholder = "Введите название населенного пункта"
        searchView.searchBarStyle = .minimal
        searchView.tableView.backgroundColor = .clear
        searchView.contentView.layer.cornerRadius = 10
        searchView.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.addSubview(searchView)
    }
    
    func configureLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
}

extension StartScreenController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        getPlace(for: location) { [weak self] (placemark) in
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let coordinateRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self?.mapView.setRegion(coordinateRegion, animated: true)
            guard let city = placemark?.locality else { return }
            SettingsManager.sharedInstance.cityName = city
            DispatchQueue.main.async {
                self?.searchView.searchBarTextField.text = city
            }
        }
    }
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
}

extension StartScreenController: JKBottomSearchDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.placeLabel.text = "Place \(indexPath.row)"
        cell.addressLabel.text = "Adress of this place"
        cell.backgroundColor = .clear
        cell.imageView?.image = placeMarkerImage.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .white
        cell.circleView.backgroundColor = .blue
        cell.circleView.layer.cornerRadius = cell.circleView.frame.width/2
        cell.selectionStyle = .gray
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = CurrentWeatherViewController.instantiate(fromStoryboard: .main)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension StartScreenController: JKBottomSearchViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //TODO implement action for searching text
    }
}
