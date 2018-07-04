//
//  ListDrinkCreateView.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 19/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ListDrinkCreateView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var tapCloseList: (() ->())?
    var tapDetailDrink: (() ->())?
    @IBOutlet weak var collectionView: UICollectionView!
    var arrDrinks = [DrinkObj]()
    var arrDatas = [Any?]()
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var indexPathCell: IndexPath?
    var createDrinkCollect = CreateDrinkCollect.init(frame: .zero)
    @IBOutlet weak var topListSearch: NSLayoutConstraint!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func doClose(_ sender: Any) {
        arrDatas.removeAll()
        UIView.animate(views: collectionView!.visibleCells,
                       animations: animations, reversed: true,
                       initialAlpha: 1.0,
                       finalAlpha: 0.0,
                       completion: {
                        self.collectionView?.reloadData()
                        self.tapCloseList?()
        })
    }
    
    func registerCell()
    {
        self.collectionView.register(UINib(nibName: "CreateDrinkCollect", bundle: nil), forCellWithReuseIdentifier: "CreateDrinkCollect")
        arrDatas = Array.init(repeating: nil, count: arrDrinks.count)
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.visibleCells,
                           animations: animations, completion: {

            })
            
        }, completion: nil)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateDrinkCollect", for: indexPath) as! CreateDrinkCollect
        let obj = arrDrinks[indexPath.row]
        if obj.image != nil {
            cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                
            })
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         createDrinkCollect = self.collectionView.cellForItem(at: indexPath) as! CreateDrinkCollect
        indexPathCell = indexPath
        self.tapDetailDrink?()
    }
}
