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
    
    private var cityWasSelected = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayAlert()
    }
    
    func displayAlert() {
        let alertTitle = "Город"
        let alertMessage = "Введите название города"
        let alertTextFieldPlaceholder = "Название города"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let defaultCityName = "Penza"
        
        alert.addTextField() { (textField) -> Void in
            textField.text = defaultCityName
            textField.placeholder = alertTextFieldPlaceholder
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                 let city = textField.text!
                if !city.isEmpty {
                SettingsManager.sharedInstance.cityName = city
                //CityManager.city.name = city
                self.cityWasSelected = true
                self.selectTabWithIndex(1)
                } else {
                    self.displayAlert()
                }
            }
        })

        //Add "Cancel" button if city was selected
        if cityWasSelected {
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                self.selectTabWithIndex(1)
            })
            alert.addAction(cancel)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectTabWithIndex(_ tabIndex: Int) {
        self.tabBarController?.selectedIndex = tabIndex
    }
}
