//
//  MainBarViewCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MainBarViewCell: UICollectionViewCell {

    @IBOutlet weak var leaningSubX: NSLayoutConstraint!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doFav(_ sender: Any) {
        CommonHellper.animateButton(view: btnFav)
    }
    
}
