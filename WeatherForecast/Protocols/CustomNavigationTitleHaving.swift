//
//  CustomNavigationTitleHaving.swift
//  WeatherForecast
//
//  Created by Михаил Избродин on 28/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol CustomNavigationTitleHaving {
    
}

extension CustomNavigationTitleHaving where Self: UIViewController {
    func setupCustomNavigationItemTitle(fontSize: CGFloat = 34, color: UIColor = .black) {
        let navLabel = UILabel() 
        let navTitle = NSMutableAttributedString(string: self.title ?? "", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: color])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
}
