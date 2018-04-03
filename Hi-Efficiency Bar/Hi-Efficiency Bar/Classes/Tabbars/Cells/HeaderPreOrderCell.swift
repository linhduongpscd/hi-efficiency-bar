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
    @IBOutlet weak var tblOrder: UITableView!
    @IBOutlet weak var ic_repeat: UIImageView!
    var isMore = false
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
        rotationAnimation.duration = 0.4
        rotationAnimation.repeatCount = 1
        
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
            rotationAnimation.duration = 0.4
            rotationAnimation.repeatCount = 1
            
            CATransaction.setCompletionBlock {
                self.tapShowCurrentOrder?()
            }
            self.ic_repeat.layer.add(rotationAnimation, forKey: nil)
            CATransaction.commit()
        }
        self.ic_repeat.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
     
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isMore {
            return 3
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isMore {
            if indexPath.row == 2
            {
                return 30
            }
        }
        else{
            if indexPath.row == 4
            {
                return 30
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isMore {
            if indexPath.row == 2
            {
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "ShowMorePreCell") as! ShowMorePreCell
                if isMore
                {
                    cell.imgDownUp.image = #imageLiteral(resourceName: "ic_up")
                    cell.lblText.text = "Hide 2 more"
                }
                else{
                    cell.imgDownUp.image = #imageLiteral(resourceName: "ic_down")
                    cell.lblText.text = "Show 2 more"
                }
                return cell
            }
            let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
            if indexPath.row == 1 {
                cell.subLine.isHidden = true
            }
            else{
                cell.subLine.isHidden = false
            }
            return cell
        }
        else{
            if indexPath.row == 4
            {
                let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "ShowMorePreCell") as! ShowMorePreCell
                if isMore
                {
                    cell.imgDownUp.image = #imageLiteral(resourceName: "ic_up")
                    cell.lblText.text = "Hide 2 more"
                }
                else{
                    cell.imgDownUp.image = #imageLiteral(resourceName: "ic_down")
                    cell.lblText.text = "Show 2 more"
                }
                return cell
            }
            let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
            if indexPath.row == 1 {
                cell.subLine.isHidden = true
            }
            else{
                cell.subLine.isHidden = false
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isMore {
            if indexPath.row == 2
            {
                isMore = true
            }
        }
        else{
            if indexPath.row == 4
            {
                 isMore = false
            }
        }
        self.tblOrder.reloadData()
        self.tapShowMoreHeader?()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: .zero)
        return view
    }
}
