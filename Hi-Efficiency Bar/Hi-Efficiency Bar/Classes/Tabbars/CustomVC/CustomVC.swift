//
//  CustomVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CustomVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = [Character]()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblCustom: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Custom"
        self.setupLayout()
        self.items = self.createItems()
        self.currentPage = 0
        self.registerCell()
        // Do any additional setup after loading the view.
    }
    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            lblName.text = character.name
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
    
    func registerCell()
    {
        tblCustom.register( UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tblCustom.register( UINib(nibName: "HeaderCustomCell", bundle: nil), forCellReuseIdentifier: "HeaderCustomCell")
        tblCustom.register( UINib(nibName: "FooterCustomCell", bundle: nil), forCellReuseIdentifier: "FooterCustomCell")
    }
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 60)
    }
    
    fileprivate func createItems() -> [Character] {
        let characters = [
            Character(imageName: "bottle", name: "Wall-E", movie: "Wall-E"),
            Character(imageName: "bottle", name: "Nemo", movie: "Finding Nemo"),
            Character(imageName: "bottle", name: "Remy", movie: "Ratatouille"),
            Character(imageName: "bottle", name: "Buzz Lightyear", movie: "Toy Story"),
            Character(imageName: "bottle", name: "Mike & Sullivan", movie: "Monsters Inc."),
            Character(imageName: "bottle", name: "Merida", movie: "Brave")
        ]
        return characters
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
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CustomVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        cell.lblTitleCell.text = "Rum brand \(indexPath.row + 1) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "HeaderCustomCell") as! HeaderCustomCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "FooterCustomCell") as! FooterCustomCell
        return cell.contentView
    }
}
