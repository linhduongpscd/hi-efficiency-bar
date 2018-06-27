//
//  PreOrderCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class PreOrderCell: UITableViewCell {
    var tapPreOrderProduct:(() ->())?
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var subLine: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var productObj = ProductObj.init(dict: NSDictionary.init())
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doRepeat(_ sender: Any) {
        CATransaction.begin()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = kSPEED_REODER
        rotationAnimation.repeatCount = 1
        CATransaction.setCompletionBlock {
            ManagerWS.shared.reorderTab(order_id: self.productObj.id!, complete: { (success, error) in
                if !success!
                {
                    APP_DELEGATE.mainBarVC?.showAlertMessage(message: error!)
                }
                else{
                    self.tapPreOrderProduct?()
                }
                
            })
            
        }
//        CATransaction.setCompletionBlock {
//            CATransaction.begin()
//            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
//            rotationAnimation.duration = 0.4
//            rotationAnimation.repeatCount = 1
//
//
//            self.btnRepeat.layer.add(rotationAnimation, forKey: nil)
//            CATransaction.commit()
//        }
        self.btnRepeat.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
    }
}
