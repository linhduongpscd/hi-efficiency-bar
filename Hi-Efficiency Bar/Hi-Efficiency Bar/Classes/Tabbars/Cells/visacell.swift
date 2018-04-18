//
//  visacell.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 13/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class visacell: UITableViewCell {
    var tapStripeVisa: (() ->())?
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTotalPay: UILabel!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblNumberHide: UILabel!
    @IBOutlet weak var lblLastCard: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doVisa(_ sender: Any) {
        self.tapStripeVisa?()
    }
}
