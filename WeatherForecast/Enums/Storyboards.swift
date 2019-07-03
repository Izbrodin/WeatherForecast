//
//  Storyboards.swift
//  WeatherForecast
//
//  Created by Михаил Избродин on 28/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

enum Storyboards: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    func instantiateViewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        guard let vc = instance.instantiateViewController(withIdentifier: String(describing: viewControllerClass)) as? T else {
            fatalError("ViewController with identifier \(String(describing: viewControllerClass)), not found in \(rawValue)")
        }
        return vc
    }
}
