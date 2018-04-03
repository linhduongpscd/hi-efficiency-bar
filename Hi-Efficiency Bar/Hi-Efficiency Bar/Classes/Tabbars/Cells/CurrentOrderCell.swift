//
//  CurrentOrderCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CurrentOrderCell: UITableViewCell {

    @IBOutlet weak var spaceButtom: UIView!
    @IBOutlet weak var spaceTop: UIView!
    @IBOutlet weak var subContent: UIViewX!
    @IBOutlet weak var doTimeLine: UIViewX!
    @IBOutlet weak var bgTranfer: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
