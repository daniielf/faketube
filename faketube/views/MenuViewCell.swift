//
//  MenuViewCell.swift
//  faketube
//
//  Created by Daniel Freitas on 15/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {

    @IBOutlet weak var tabIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isHighlighted: Bool {
        didSet {
            tabIcon.tintColor = !self.isHighlighted ? UIColor.useRawValues(red: 80, green: 30, blue: 30) : .white
        }
    }
    
    override var isSelected: Bool {
        didSet {
            tabIcon.tintColor = !self.isSelected ? UIColor.useRawValues(red: 80, green: 30, blue: 30) : .white
        }
    }

}
