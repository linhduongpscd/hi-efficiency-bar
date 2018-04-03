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
    @IBOutlet weak var btnRum1: UIButtonX!
    var istick1 = true
     var istick2 = true
     var istick3 = true
     var istick4 = true
    @IBOutlet weak var btnRum2: UIButtonX!
    @IBOutlet weak var btnRum3: UIButtonX!
    @IBOutlet weak var btnRum4: UIButtonX!
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
        if !istick1
        {
            btnRum1.borderWidth = 3.0
            btnRum1.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
            btnRum1.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Bold, size: (btnRum1.titleLabel?.font.pointSize)!)
        }
        else{
            btnRum1.borderWidth = 1.0
            btnRum1.borderColor =  UIColor.clear
            btnRum1.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: (btnRum1.titleLabel?.font.pointSize)!)
        }
    }
    @IBAction func doYock2(_ sender: Any) {
        istick2 = !istick2
        imgTick2.isHidden = istick2
        if !istick2
        {
            btnRum2.borderWidth = 3.0
            btnRum2.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
            btnRum2.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Bold, size: (btnRum2.titleLabel?.font.pointSize)!)
        }
        else{
            btnRum2.borderWidth = 1.0
            btnRum2.borderColor =  UIColor.clear
            btnRum2.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: (btnRum2.titleLabel?.font.pointSize)!)
        }
    }
    @IBAction func doYock3(_ sender: Any) {
        istick3 = !istick3
        imgTick3.isHidden = istick3
        if !istick3
        {
            btnRum3.borderWidth = 3.0
            btnRum3.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
            btnRum3.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Bold, size: (btnRum3.titleLabel?.font.pointSize)!)
        }
        else{
            btnRum3.borderWidth = 1.0
            btnRum3.borderColor =  UIColor.clear
            btnRum3.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: (btnRum3.titleLabel?.font.pointSize)!)
        }
    }
    @IBAction func doYock4(_ sender: Any) {
        istick4 = !istick4
        imgTick4.isHidden = istick4
        if !istick4
        {
            btnRum4.borderWidth = 3.0
            btnRum4.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
            btnRum4.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Bold, size: (btnRum4.titleLabel?.font.pointSize)!)
        }
        else{
            btnRum4.borderWidth = 1.0
            btnRum4.borderColor =  UIColor.clear
            btnRum4.titleLabel?.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: (btnRum4.titleLabel?.font.pointSize)!)
        }
    }
}
