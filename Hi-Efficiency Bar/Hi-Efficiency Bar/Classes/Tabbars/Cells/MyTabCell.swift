//
//  MyTabCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MyTabCell: UITableViewCell {
    var tapDeleteMyTab: (() ->())?
    var changePrice: (() ->())?
    @IBOutlet weak var lblQuanlity: UILabel!
    var numberQuanlity = 1
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var subLine: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    var indexPathCell: IndexPath?
    var myTabObj: MyTabObj?
    @IBOutlet weak var btnAm: UIButtonX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doTang(_ sender: Any) {
        btnAm.isEnabled = false
        numberQuanlity = (myTabObj?.quantity!)! + 1
        lblQuanlity.text = "\(numberQuanlity)"
        CommonHellper.animateViewSmall(view: lblQuanlity)
        if myTabObj?.price == nil
        {
            lblPrice.text = "$0"
        }
        else{
            let value = Double((Double(numberQuanlity) * (myTabObj?.price!)!))
            print(value)
              lblPrice.text = "$\(value)"
           
        }
        ManagerWS.shared.updateMyTab(tabID: (myTabObj?.id!)!, quantity: numberQuanlity, complete: { (success) in
            self.btnAm.isEnabled = true
            self.myTabObj?.quantity = (self.myTabObj?.quantity)! + 1
             self.changePrice?()
        })
    }
    @IBAction func doGiam(_ sender: Any) {
        btnAm.isEnabled = false
        numberQuanlity = (myTabObj?.quantity!)!
        if numberQuanlity == 1
        {
            self.tapDeleteMyTab?()
             self.btnAm.isEnabled = true
        }
        else{
            
            numberQuanlity = (myTabObj?.quantity!)! - 1
            lblQuanlity.text = "\(numberQuanlity)"
            CommonHellper.animateViewSmall(view: lblQuanlity)
            if myTabObj?.price == nil
            {
                lblPrice.text = "$0"
            }
            else{
                let value = Double((Double(numberQuanlity) * (myTabObj?.price!)!))
                lblPrice.text = "$\(value)"
                
            }
            ManagerWS.shared.updateMyTab(tabID: (myTabObj?.id!)!, quantity: numberQuanlity, complete: { (success) in
                self.myTabObj?.quantity = (self.myTabObj?.quantity)! - 1
                self.changePrice?()
                self.btnAm.isEnabled = true
            })
            
        }
    }
}
