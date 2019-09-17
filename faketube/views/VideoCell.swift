//
//  VideoCell.swift
//  faketube
//
//  Created by Daniel Freitas on 15/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var views_count: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lightGray
    }
    
}
