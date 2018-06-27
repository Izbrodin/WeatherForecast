//
//  StartScreenController.swift
//  WeatherForecast
//
//  Created by Admin on 25.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class StartScreenController: UIViewController {
    private var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayAlert()
    }
    
    func displayAlert() {
        let alertTitle = "Город"
        let alertMessage = "Введите название города"
        let alertTextFieldPlaceholder = "Название города"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField {(textField) -> Void in
            textField.placeholder = alertTextFieldPlaceholder
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                self.city = textField.text
                
                if let currentWeatherViewController = self.tabBarController?.viewControllers![1] as? CurrentWeatherViewController {
                    currentWeatherViewController.city = self.city
                }
                
                if let weatherForecastViewController = self.tabBarController?.viewControllers![2] as? WeatherForecastViewController{
                    weatherForecastViewController.city = self.city
                }

                self.tabBarController?.selectedIndex = 1
            }
        })

        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in
         self.tabBarController?.selectedIndex = 1
        })
         alert.addAction(cancel)
        
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToCurrentWeather") {
            
            if let secTab = self.tabBarController?.viewControllers![1] as? CurrentWeatherViewController {
                secTab.city = self.city
            }
        }
    }
}
