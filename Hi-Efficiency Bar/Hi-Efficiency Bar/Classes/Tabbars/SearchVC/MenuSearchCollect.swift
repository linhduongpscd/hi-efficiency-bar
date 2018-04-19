//
//  MenuSearchCollect.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 27/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MenuSearchCollect: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var arrmenus = [#imageLiteral(resourceName: "ing_1"), #imageLiteral(resourceName: "ing_2"), #imageLiteral(resourceName: "ing_3"), #imageLiteral(resourceName: "ing_4"), #imageLiteral(resourceName: "ing_5"), #imageLiteral(resourceName: "ing_6")]
    var arrNames = ["Basics", "Spirits","Liquers","Mixers","Other","Fruits"]
    @IBOutlet weak var collectionView: UICollectionView!
    var indexSelect = 0
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var subSearch: UIViewX!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txfSearch: UITextField!
    var badgeBasics = 0
     var badgeSpirits = 0
     var badgeLiquers = 0
     var badgeMixers = 0
     var badgeOther = 0
     var badgeFruits = 0
     var tapSelectMenu: (() ->())?
    var tapBeginSearch: (() ->())?
    var tapDoneSearch: (() ->())?
    var tapReturnSearch: (() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.text = arrNames[indexSelect]
        subSearch.isHidden = true
        // Initialization code
    }

    func registerCell()
    {
        self.collectionView.register(UINib(nibName: "IngreCollect", bundle: nil), forCellWithReuseIdentifier: "IngreCollect")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arrmenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreCollect", for: indexPath) as! IngreCollect
        cell.imgCell.image = arrmenus[indexPath.row]
        if indexSelect == indexPath.row {
            cell.spaceTop.isHidden = false
            cell.spaceBottom.isHidden = false
        }
        else{
            cell.spaceTop.isHidden = true
            cell.spaceBottom.isHidden = true
        }
        switch indexPath.row {
        case 0:
            if badgeBasics == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeBasics)"
            }
            break
        case 1:
            if badgeSpirits == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeSpirits)"
            }
            break
        case 2:
            if badgeLiquers == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeLiquers)"
            }
            break
        case 3:
            if badgeMixers == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeMixers)"
            }
            break
        case 4:
            if badgeOther == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeOther)"
            }
            break
        case 5:
            if badgeFruits == 0
            {
                cell.lblBadge.isHidden = true
            }
            else{
                cell.lblBadge.isHidden = false
                cell.lblBadge.text = "\(badgeFruits)"
            }
            break
        default:
            cell.lblBadge.isHidden = true
            break
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: (collectionView.frame.size.width)/6, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexSelect = indexPath.row
        lblName.text = arrNames[indexSelect]
        collectionView.reloadData()
        subSearch.isHidden = true
        lblName.isHidden = false
        btnSearch.isHidden = false
        txfSearch.resignFirstResponder()
        self.tapSelectMenu?()
    }
    @IBAction func doSearch(_ sender: Any) {
        txfSearch.text = ""
         subSearch.isHidden = false
        lblName.isHidden = true
        btnSearch.isHidden = true
        self.tapBeginSearch?()
        txfSearch.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.tapReturnSearch?()
        txfSearch.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    @IBAction func doDoneSearch(_ sender: Any) {
        subSearch.isHidden = true
        lblName.isHidden = false
        btnSearch.isHidden = false
        txfSearch.resignFirstResponder()
        self.tapDoneSearch?()
    }
    
}
