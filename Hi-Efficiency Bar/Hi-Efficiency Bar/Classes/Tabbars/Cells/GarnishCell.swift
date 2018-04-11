//
//  GarnishCell.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 09/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class GarnishCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
