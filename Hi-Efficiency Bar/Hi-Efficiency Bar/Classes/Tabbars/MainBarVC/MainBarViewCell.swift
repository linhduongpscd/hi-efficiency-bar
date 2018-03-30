//
//  MainBarViewCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MainBarViewCell: UICollectionViewCell {

    @IBOutlet weak var leaningSubX: NSLayoutConstraint!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var constraintBottomBtnFav: NSLayoutConstraint!
    var isFav = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doFav(_ sender: Any) {
        if !isFav
        {
            isFav = true
            btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
        }
        else{
            isFav = false
            btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
        }
       
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.constraintBottomBtnFav.constant = 25
                        self.btnFav.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.25) {
                            self.constraintBottomBtnFav.constant = 10
                            self.btnFav.transform = CGAffineTransform.identity
                        }
        })
    }
    
}
