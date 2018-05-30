//
//  HeaderViewCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
class HeaderViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var tapHeaderMainBar: (() ->())?
    @IBOutlet weak var collectionView: UICollectionView!
     var items = [MainBarObj]()
    var isCustom = false
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var bgItem: UIImageView!
    var subBG = CommonHellper.CreateaddBlurView(_einView: UIView.init())
    var currentPage: Int = 0 {
        didSet {
            if self.items.count > 0 {
                let mainBarObj = self.items[self.currentPage]
                lblName.text = mainBarObj.name
                self.bgItem.sd_setImage(with: URL.init(string: mainBarObj.image!), completed: { (image, error, type, url) in
                    self.subBG.removeFromSuperview()
                    self.subBG = CommonHellper.CreateaddBlurView(_einView: self.bgItem)
                    self.bgItem.addSubview(self.subBG)
                   //CommonHellper.addBlurView(self.bgItem)
                })
                if isCustom
                {
                    self.tapHeaderMainBar?()
                }
            }
            else{
                lblName.text  = ""
            }
        }
    }
    //UIStoryboard.init(name: "Main", bundle: nil)
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 60)
    }
    func initRegisterCollect()
    {
        self.setupLayout()
        self.currentPage = 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let character = items[(indexPath as NSIndexPath).row]
        if character.image != nil
        {
             cell.image.backgroundColor = UIColor.clear
            cell.image.sd_setImage(with: URL.init(string: character.image!), completed: { (image, error, type, url) in
                
            })
        }
        else{
            cell.image.backgroundColor = UIColor.groupTableViewBackground
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapHeaderMainBar?()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: 200, height: 260)
    }
}
