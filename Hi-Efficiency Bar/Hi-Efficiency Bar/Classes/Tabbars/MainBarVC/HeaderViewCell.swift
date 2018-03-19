//
//  HeaderViewCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let character = items[(indexPath as NSIndexPath).row]
        cell.image.image = UIImage(named: character.imageName)
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
}
