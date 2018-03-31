//
//  CurrentOrderCollect.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/31/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CurrentOrderCollect: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblCustom: UITableView!
    var numberPage = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func registerCell()
    {
        self.tblCustom.register(UINib(nibName: "CurrentOrderCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
          self.tblCustom.register(UINib(nibName: "FooterCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "FooterCurrentOrderCell")
        self.tblCustom.register(UINib(nibName: "HeaderCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderCurrentOrderCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberPage % 2 == 0 {
            return 5
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
        if indexPath.row == 0 {
            cell.spaceTop.isHidden = true
        }
        else{
            cell.spaceTop.isHidden = false
        }
        if numberPage % 2 == 0 {
            if indexPath.row == 4 {
                cell.subContent.backgroundColor =  UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
                cell.spaceButtom.backgroundColor = UIColor.lightGray
                cell.doTimeLine.backgroundColor = UIColor.lightGray
            }
            else{
                cell.subContent.backgroundColor = UIColor.white
                cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
                cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            }
        }
        else{
            if indexPath.row == 2 {
                cell.subContent.backgroundColor =  UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
                cell.spaceButtom.backgroundColor = UIColor.lightGray
                cell.doTimeLine.backgroundColor = UIColor.lightGray
            }
            else{
                cell.subContent.backgroundColor = UIColor.white
                cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
                cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "FooterCurrentOrderCell") as! FooterCurrentOrderCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "HeaderCurrentOrderCell") as! HeaderCurrentOrderCell
        return cell.contentView
    }
}
