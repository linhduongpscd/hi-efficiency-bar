//
//  MenuSearchCollect.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 27/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MenuSearchCollect: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var arrmenus = [#imageLiteral(resourceName: "ing_1"), #imageLiteral(resourceName: "ing_2"), #imageLiteral(resourceName: "ing_3"), #imageLiteral(resourceName: "ing_4"), #imageLiteral(resourceName: "ing_5"), #imageLiteral(resourceName: "ing_6")]
    @IBOutlet weak var collectionView: UICollectionView!
    var indexSelect = 0
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        return CGSize(width: (collectionView.frame.size.width)/6, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexSelect = indexPath.row
        collectionView.reloadData()
    }
}
