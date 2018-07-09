//
//  ExpandableHeaderView.swift
//  WeatherForecast
//
//  Created by Admin on 15.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandableHeaderViewDelegate: {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleSection(header: self, section: self.section)
    }
            
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.titleLabel.text = title
        self.section = section
        self.delegate = delegate
    }
}
