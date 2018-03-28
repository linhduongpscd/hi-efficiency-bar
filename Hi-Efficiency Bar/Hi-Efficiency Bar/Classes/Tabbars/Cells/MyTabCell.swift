//
//  MyTabCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MyTabCell: UITableViewCell {

    @IBOutlet weak var lblQuanlity: UILabel!
    var numberQuanlity = 1
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doTang(_ sender: Any) {
        numberQuanlity = numberQuanlity + 1
        lblQuanlity.text = "\(numberQuanlity)"
        CommonHellper.animateViewSmall(view: lblQuanlity)
        lblPrice.text = "$\(numberQuanlity*35).00"
    }
    @IBAction func doGiam(_ sender: Any) {
        if numberQuanlity > 1 {
            numberQuanlity = numberQuanlity - 1
            lblQuanlity.text = "\(numberQuanlity)"
       CommonHellper.animateViewSmall(view: lblQuanlity)
             lblPrice.text = "$\(numberQuanlity*35).00"
        }
    }
}
