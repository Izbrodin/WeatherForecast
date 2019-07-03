//  UIViewControllerExtensions.swift
//  WeatherForecast
//
//  Created by Admin on 28.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayErrorAlert(_ errorText: String) {
        let alert = UIAlertController(title: "Ошибка", message: errorText, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    static func instantiate(fromStoryboard storyboard: Storyboards) -> Self {
        return storyboard.instantiateViewController(viewControllerClass: self)
    }
}
