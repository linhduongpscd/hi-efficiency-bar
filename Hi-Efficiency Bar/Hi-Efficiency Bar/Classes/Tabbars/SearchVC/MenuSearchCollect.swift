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
    }
    @IBAction func doSearch(_ sender: Any) {
         subSearch.isHidden = false
        lblName.isHidden = true
        btnSearch.isHidden = true
        txfSearch.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfSearch.resignFirstResponder()
        return true
    }
}
