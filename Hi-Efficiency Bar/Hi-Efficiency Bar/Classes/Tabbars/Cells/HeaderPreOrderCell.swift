//
//  HeaderPreOrderCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderPreOrderCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    var tapShowMoreHeader:(() ->())?
    var tapShowCurrentOrder:(() ->())?
    var tapReorderProduct:(() ->())?
    var tapProduct:(() ->())?
    @IBOutlet weak var tblOrder: UITableView!
    @IBOutlet weak var ic_repeat: UIImageView!
    var isMore = false
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var indexPathSelect = Int()
    var userOrderObj = OrderUserObj.init(dict: NSDictionary.init())
    override func awakeFromNib() {
         tblOrder.register( UINib(nibName: "PreOrderCell", bundle: nil), forCellReuseIdentifier: "PreOrderCell")
          tblOrder.register( UINib(nibName: "ShowMorePreCell", bundle: nil), forCellReuseIdentifier: "ShowMorePreCell")
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doRepeat(_ sender: Any) {

        
        CATransaction.begin()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = kSPEED_REODER
        rotationAnimation.repeatCount = 1
        CATransaction.setCompletionBlock {
            self.tapShowCurrentOrder?()
        }
//
//        CATransaction.setCompletionBlock {
//            CATransaction.begin()
//            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
//            rotationAnimation.duration = 0.4
//            rotationAnimation.repeatCount = 1
//
//            CATransaction.setCompletionBlock {
//                self.tapShowCurrentOrder?()
//            }
//            self.ic_repeat.layer.add(rotationAnimation, forKey: nil)
//            CATransaction.commit()
//        }
        self.ic_repeat.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
     
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ cell: PreOrderCell,_ obj: ProductObj)
    {
        if obj.image != nil
        {
            cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                
            })
        }
        
        cell.lblName.text = obj.name
        if obj.price != nil
        {
            cell.lblPrice.text = "$\(obj.price!)"
        }
        cell.productObj = obj
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userOrderObj.isLoadMore
        {
            return userOrderObj.arrProducts.count + 1
        }
        else{
            if userOrderObj.arrProducts.count > 2
            {
                return 3
            }
            else{
                return userOrderObj.arrProducts.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if userOrderObj.isLoadMore
        {
            if userOrderObj.arrProducts.count == indexPath.row
            {
                return 30
            }
            return 70
        }
        else{
            if userOrderObj.arrProducts.count > 2
            {
                if indexPath.row == 2
                {
                    return 30
                }
                return 70
            }
            else{
                return 70
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userOrderObj.isLoadMore
        {
            if indexPath.row == userOrderObj.arrProducts.count
            {
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "ShowMorePreCell") as! ShowMorePreCell
                cell.lblText.text = "Hide \(userOrderObj.arrProducts.count - 2) more"
                return cell
            }
            else{
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
                print(userOrderObj.arrProducts.count)
                print(indexPath.row)
                self.configCell(cell, userOrderObj.arrProducts[indexPath.row])
                if indexPath.row == userOrderObj.arrProducts.count - 1 {
                    cell.subLine.isHidden = true
                }
                else{
                    cell.subLine.isHidden = false
                }
                cell.tapPreOrderProduct = { [] in
                    self.tapReorderProduct?()
                }
                return cell
            }
          
        }
        else{
            if userOrderObj.arrProducts.count > 2
            {
                if indexPath.row == 2
                {
                    let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "ShowMorePreCell") as! ShowMorePreCell
                    cell.imgDownUp.image = #imageLiteral(resourceName: "ic_down")
                    cell.lblText.text = "Show \(userOrderObj.arrProducts.count - 2) more"
                    return cell
                }
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
                self.configCell(cell, userOrderObj.arrProducts[indexPath.row])
                if indexPath.row == 1 {
                    cell.subLine.isHidden = true
                }
                else{
                    cell.subLine.isHidden = false
                }
                cell.tapPreOrderProduct = { [] in
                    self.tapReorderProduct?()
                }
                return cell
            }
            else{
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
                self.configCell(cell, userOrderObj.arrProducts[indexPath.row])
                if indexPath.row == userOrderObj.arrProducts.count - 1 {
                    cell.subLine.isHidden = true
                }
                else{
                    cell.subLine.isHidden = false
                }
                cell.tapPreOrderProduct = { [] in
                    self.tapReorderProduct?()
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userOrderObj.isLoadMore
        {
            if userOrderObj.arrProducts.count == indexPath.row
            {
                self.userOrderObj.isLoadMore = false
                self.tblOrder.reloadData()
                self.tapShowMoreHeader?()
            }
            else{
                indexPathSelect = indexPath.row
                self.tapProduct?()
            }
        }
        else{
            if userOrderObj.arrProducts.count > 2
            {
                if indexPath.row == 2
                {
                    self.userOrderObj.isLoadMore = true
                    self.tblOrder.reloadData()
                    self.tapShowMoreHeader?()
                }
                else{
                   indexPathSelect = indexPath.row
                    self.tapProduct?()
                }
            }
            else{
               indexPathSelect = indexPath.row
                self.tapProduct?()
            }
           
        }
      
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: .zero)
        return view
    }
}
