//
//  DetailHeaderGenereCollect.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailHeaderGenereCollect: UICollectionViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var widthImage: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.widthImage.constant = (UIScreen.main.bounds.size.width-10)/2
        // Initialization code
    }

}
