//
//  ProfileView.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ProfileView: UIView {
   var tapChangeAvatar:(() ->())?
    var tapName:(() ->())?
    @IBOutlet weak var imgAvatar: UIImageView!    
    @IBOutlet weak var constaintAvatar: NSLayoutConstraint!
    
    @IBOutlet weak var lblName: UILabel!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        //imgAvatar.layer.masksToBounds = true
    }

    @IBAction func doChangeAvatar(_ sender: Any) {
        self.tapChangeAvatar?()
    }
    
    @IBAction func doChangeUser(_ sender: Any) {
        self.tapName?()
    }
    
   
}
