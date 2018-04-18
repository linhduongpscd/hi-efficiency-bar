//
//  CustomDetailCell.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CustomDetailCell: UITableViewCell {
    var tapRemove: (() ->())?
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txfValue: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doRemove(_ sender: Any) {
        self.tapRemove?()
    }
}
