//
//  CurrentOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CurrentOrderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionCurrent: UICollectionView!
     fileprivate var items = [Character]()
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    @IBOutlet weak var tblCurrent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionCurrent.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.tblCurrent.register(UINib(nibName: "CurrentOrderCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
         self.tblCurrent.register(UINib(nibName: "FooterCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "FooterCurrentOrderCell")
        self.tblCurrent.register(UINib(nibName: "HeaderCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderCurrentOrderCell")
        
        self.setupLayout()
        self.items = self.createItems()
        self.currentPage = 0
        heightCollection.constant = 195 + (UIScreen.main.bounds.size.width - 320)/2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            lblName.text = character.name
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionCurrent.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionCurrent.collectionViewLayout as! UPCarouselFlowLayout
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print( (UIScreen.main.bounds.size.width - 15)/3)
        return CGSize(width: 155 + (UIScreen.main.bounds.size.width - 320)/2, height:  195 + (UIScreen.main.bounds.size.width - 320)/2)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
        //let character = items[(indexPath as NSIndexPath).row]
        //cell.image.image = UIImage(named: character.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionCurrent.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

extension CurrentOrderVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
        if indexPath.row == 0 {
            cell.spaceTop.isHidden = true
        }
        else{
            cell.spaceTop.isHidden = false
        }
        if indexPath.row == 3 {
            cell.spaceButtom.isHidden = true
        }
        else{
            cell.spaceButtom.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "FooterCurrentOrderCell") as! FooterCurrentOrderCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "HeaderCurrentOrderCell") as! HeaderCurrentOrderCell
        return cell.contentView
    }
}
