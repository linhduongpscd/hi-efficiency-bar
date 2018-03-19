//
//  HeaderCustomCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/16/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderCustomCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txfSearch: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfSearch.resignFirstResponder()
        return true
    }
}
