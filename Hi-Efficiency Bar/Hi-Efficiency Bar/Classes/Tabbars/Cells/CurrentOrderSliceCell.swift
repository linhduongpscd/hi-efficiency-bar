//
//  CurrentOrderSliceCell.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 28/09/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CurrentOrderSliceCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var arrProducts = [ProductObj]()

     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {

         self.currentPage = 0
     // Drawing code
     }
            var currentDot = 0
    func registerCell()
    {
       self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.setupLayout()
       
    }
    
    var tapHeaderMainBar: (() ->())?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    fileprivate var currentPage: Int = 0 {
        didSet {
            if arrProducts.count > 0
            {
                let character = self.arrProducts[self.currentPage]
                lblName.text = character.name
                currentDot = currentPage
                print("ZO DAY")
            }
            
        }
    }
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
        return arrProducts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
        cell.lblLevel.isHidden = true
        cell.iconLevel.isHidden = true
        cell.btnFav.isHidden = true
        let obj = arrProducts[indexPath.row]
        if obj.image != nil
        {
            cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                
            })
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.tapHeaderMainBar?()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.size.width - 180, height:  195 + (UIScreen.main.bounds.size.width - 320) - 50)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
