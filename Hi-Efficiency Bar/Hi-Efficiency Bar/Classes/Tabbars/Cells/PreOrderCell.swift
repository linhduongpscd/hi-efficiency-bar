//
//  PreOrderCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class PreOrderCell: UITableViewCell {

    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var subLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doRepeat(_ sender: Any) {
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.btnRepeat.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.btnRepeat.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
        }, completion: nil)
    }
}
