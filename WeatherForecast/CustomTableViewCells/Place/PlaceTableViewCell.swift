//
//  PlaceTableViewCell.swift
//  JKBottomSearchViewExample
//
//  Created by Admin on 28.06.2019.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var circleView: UIView!
    @IBOutlet private var _imageView: UIImageView!
    override var imageView: UIImageView?{
        get{ return _imageView}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
