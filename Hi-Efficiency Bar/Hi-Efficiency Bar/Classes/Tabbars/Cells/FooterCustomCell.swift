//
//  FooterCustomCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class FooterCustomCell: UITableViewCell {
    var tapClickNext: (() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
         btnNext.spinnerColor = .white
        // Initialization code
    }
    @IBOutlet weak var btnNext: TransitionButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doNext(_ sender: TransitionButton) {
        btnNext.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnNext.setTitle("", for: .normal)
                self.btnNext.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnNext.stopAnimation(animationStyle: .shake, completion: {
                })
                 self.perform(#selector(self.clickNext), with: nil, afterDelay: 1.5)
            })
        })
    }
    
    @objc func clickNext()
    {
        self.tapClickNext?()
    }
}
