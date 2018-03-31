//
//  CustomCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/16/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblTitleCell: UILabel!
    @IBOutlet weak var imgTick1: UIImageView!
     @IBOutlet weak var imgTick2: UIImageView!
     @IBOutlet weak var imgTick3: UIImageView!
     @IBOutlet weak var imgTick4: UIImageView!
    var istick1 = true
     var istick2 = true
     var istick3 = true
     var istick4 = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doYock1(_ sender: Any) {
        istick1 = !istick1
        imgTick1.isHidden = istick1
    }
    @IBAction func doYock2(_ sender: Any) {
        istick2 = !istick2
        imgTick2.isHidden = istick2
    }
    @IBAction func doYock3(_ sender: Any) {
        istick3 = !istick3
        imgTick3.isHidden = istick3
    }
    @IBAction func doYock4(_ sender: Any) {
        istick4 = !istick4
        imgTick4.isHidden = istick4
    }
}
