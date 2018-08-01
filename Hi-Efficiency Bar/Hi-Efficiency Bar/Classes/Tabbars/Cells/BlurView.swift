//
//  BlurView.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 20/07/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class BlurView: UIView {
    @IBOutlet weak var lblNumberOnTray: UILabel!
    @IBOutlet weak var imgQrCode: UIImageView!
    var userOrderObj = OrderUserObj.init(dict: NSDictionary.init())
    @IBOutlet weak var spaceRight: NSLayoutConstraint!
    @IBOutlet weak var spaceTop: NSLayoutConstraint!
    @IBOutlet weak var subContent: UIView!
    var tapClose: (() ->())?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func registerBlurView()
    {
        if userOrderObj.tray_number != nil
        {
            self.lblNumberOnTray.text = "Pick up on tray: \(userOrderObj.tray_number!)"
        }
        
        if userOrderObj.qr_code != nil
        {
            self.imgQrCode.sd_setImage(with: URL.init(string: userOrderObj.qr_code!), completed: { (image, error, type, url) in
                
            })
        }
        if UIScreen.main.bounds.size.height == 812.0 {
            self.spaceTop.constant = 112.0
            self.spaceRight.constant = 115.0
        } else if UIScreen.main.bounds.size.height == 736.0 {
            self.spaceTop.constant = 120.0
            self.spaceRight.constant = 130.0
        }
        else if UIScreen.main.bounds.size.height == 667.0 {
            self.spaceTop.constant = 95.0
            self.spaceRight.constant = 118.0
        }
        else if UIScreen.main.bounds.size.height == 568.0 {
            self.spaceTop.constant = 50.0
            self.spaceRight.constant = 95.0
        }
    }
    @IBAction func doClose(_ sender: Any) {
        self.tapClose?()
    }
}
