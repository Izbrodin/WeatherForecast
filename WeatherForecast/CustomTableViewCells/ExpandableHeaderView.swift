//
//  ExpandableHeaderView.swift
//  WeatherForecast
//
//  Created by Admin on 15.06.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandableHeaderViewDelegate: class {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private weak var delegate: ExpandableHeaderViewDelegate?
    private var section: Int?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        section = nil
        delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        if let section = section {
            delegate?.toggleSection(header: self, section: section)
        }
    }
            
    func update(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.titleLabel.text = title
        self.section = section
        self.delegate = delegate
    }
}
