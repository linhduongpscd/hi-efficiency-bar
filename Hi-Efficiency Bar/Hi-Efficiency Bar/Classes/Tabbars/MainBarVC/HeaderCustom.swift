//
//  HeaderCustom.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 23/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderCustom: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func registerCell()
    {
        if isListOrder {
             self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        }
        else{
             self.collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        }
        
        self.setupLayout()
        self.items = self.createItems()
        
        self.currentPage = 0
    }
    var isListOrder = Bool()
    var tapHeaderMainBar: (() ->())?
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = [Character]()
    @IBOutlet weak var lblName: UILabel!
    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            lblName.text = character.name
            print("ZO DAY")
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
    
    fileprivate func createItems() -> [Character] {
        let characters = [
            Character(imageName: "cocktail", name: "Wall-E", movie: "Wall-E"),
            Character(imageName: "cocktail", name: "Nemo", movie: "Finding Nemo"),
            Character(imageName: "cocktail", name: "Remy", movie: "Ratatouille"),
            Character(imageName: "cocktail", name: "Buzz Lightyear", movie: "Toy Story"),
            Character(imageName: "cocktail", name: "Mike & Sullivan", movie: "Monsters Inc."),
            Character(imageName: "cocktail", name: "Merida", movie: "Brave")
        ]
        return characters
    }
    func initRegisterCollect()
    {
        self.setupLayout()
        self.items = self.createItems()
        
        self.currentPage = 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListOrder {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            return cell
        }
        
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
        if !isListOrder {
            return CGSize(width: 200, height: 210)
        }
        
        return CGSize(width: 155, height:  195 + (UIScreen.main.bounds.size.width - 320) - 50)
    }
}
