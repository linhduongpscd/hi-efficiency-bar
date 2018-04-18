//
//  IngreCollect.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/21/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class IngreCollect: UICollectionViewCell {
    @IBOutlet weak var spaceTop: UIView!
    @IBOutlet weak var spaceBottom: UIView!
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblBadge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblBadge.layer.cornerRadius = 10
        lblBadge.layer.masksToBounds = true
    }
}
