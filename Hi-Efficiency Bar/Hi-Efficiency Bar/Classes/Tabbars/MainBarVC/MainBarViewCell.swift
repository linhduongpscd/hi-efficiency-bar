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
    @IBOutlet weak var lblName: UILabel!
    var isFav = false
    var drinkObj = DrinkObj.init(dict: NSDictionary.init())
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doFav(_ sender: Any) {
//        if !isFav
//        {
//            isFav = true
//            //btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
//             btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
//        }
//        else{
//            isFav = false
//            btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
//        }
       
        if !drinkObj.is_favorite! {
            drinkObj.is_favorite = true
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
                            self.constraintBottomBtnFav.constant = 25
                            self.btnFav.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.25) {
                                self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
                                self.constraintBottomBtnFav.constant = 10
                                self.btnFav.transform = CGAffineTransform.identity
                            }
            })
           
        }
        else{
             drinkObj.is_favorite = false
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
                            self.constraintBottomBtnFav.constant = 25
                            self.btnFav.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.25) {
                                self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
                                self.constraintBottomBtnFav.constant = 10
                                self.btnFav.transform = CGAffineTransform.identity
                            }
            })
        }
        ManagerWS.shared.favUnFavDrink(drinkID: drinkObj.id!, complete: { (success) in
            
        })
        
    }
    
    
    func configCell(drinkObj: DrinkObj)
    {
        self.drinkObj = drinkObj
        self.lblName.text = drinkObj.name
        if drinkObj.image != nil{
            self.imgCell.sd_setImage(with: URL.init(string: drinkObj.image!), completed: { (image, error, type, url) in
                
            })
        }
        else{
            self.imgCell.image = UIImage.init()
        }
        if drinkObj.is_favorite!
        {
            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
        }
        else{
            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
        }
    }
}
