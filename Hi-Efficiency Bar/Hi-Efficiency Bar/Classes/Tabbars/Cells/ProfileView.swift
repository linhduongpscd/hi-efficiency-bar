//
//  ProfileView.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    var tapCurrentOrder:(() ->())?
    var tapPreOrder:(() ->())?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func doCurrentOrder(_ sender: Any) {
        self.tapCurrentOrder?()
    }
    @IBAction func doPreOrder(_ sender: Any) {
        self.tapPreOrder?()
    }
}
