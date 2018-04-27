//
//  MainBarVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MainBarVC: BaseViewController, ASFSharedViewTransitionDataSource {
    @IBOutlet weak var subNavi: UIView!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    var arrSlices = [MainBarObj]()
    var offset = 0
    var isLoadMore = false
    var arrDrinks = [DrinkObj]()
    var drinkObj = DrinkObj.init(dict: NSDictionary.init())
    var indexPathCell: IndexPath?
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    
    override func viewDidLoad() {
        ASFSharedViewTransition.addWith(fromViewControllerClass: MainBarVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
        self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.collectionView.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")
        self.collectionView.register(UINib(nibName: "FooterMainBarCollect", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterMainBarCollect")
       self.configHideNaviScroll(collectionView)
       self.getSliceHeader()
       self.fetchAllDrink()
        self.callSetting()
    }
    
    func callSetting()
    {
        ManagerWS.shared.getSettingApp { (success) in
            if !success!
            {
                let alert = UIAlertController(title: nil,
                                              message: "Bar was close, cannot order.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configRefresh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        //DO
    }
    
    func getSliceHeader()
    {
        ManagerWS.shared.getMainBar { (success, arrs) in
            self.arrSlices = arrs!
            self.collectionView.reloadData()
        }
    }
    
    
    func fetchAllDrink()
    {
        //CommonHellper.showBusy()
        ManagerWS.shared.getListDrink(offset: offset) { (success, arrs) in
            CommonHellper.hideBusy()
            if arrs!.count > 0
            {
                self.isLoadMore = true
            }
            else{
                self.isLoadMore = false
            }
            for drink in arrs!
            {
                self.arrDrinks.append(drink)
            }
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    func sharedView() -> UIView! {
        if ((collectionView.indexPathsForSelectedItems?.first) != nil)
        {
            if let cell = collectionView.cellForItem(at: (collectionView.indexPathsForSelectedItems?.first)!) as? MainBarViewCell
            {
                if cell.drinkObj.is_favorite!
                {
                    cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
                }
                else{
                    cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
                }
                return cell.imgCell
            }
            return UIView.init()
        }
        else{
            return UIView.init()
        }
       
    }
}



extension MainBarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        return arrDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderViewCell", for: indexPath) as! HeaderViewCell
            cell.initRegisterCollect()
            cell.items = self.arrSlices
            cell.collectionView.reloadData()
            if self.arrSlices.count > 0
            {
                let obj = self.arrSlices[cell.currentPage]
                cell.lblName.text = obj.name
            }
            cell.tapHeaderMainBar = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
                vc.mainBarObj = (self?.arrSlices[cell.currentPage])!
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
        cell.configCell(drinkObj: self.arrDrinks[indexPath.row])
        if indexPath.row % 2 == 0 {
             cell.leaningSubX.constant = 0.0
        }
        else{
            cell.leaningSubX.constant = 5.0
        }
        
        return cell
     
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isLoadMore && self.arrDrinks.count/2 == indexPath.row - 1 {
            print("VAO DAY")
            isLoadMore = false
            self.offset = self.offset + kLimitPage
            self.fetchAllDrink()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
         if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 260)
        }
        
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
               mainBarViewCell = self.collectionView.cellForItem(at: indexPath) as! MainBarViewCell
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.mainBarViewCell.frame = CGRect(x:self.mainBarViewCell.frame.origin.x, y: self.mainBarViewCell.frame.origin.y - 15, width: self.mainBarViewCell.frame.size.width, height: self.mainBarViewCell.frame.size.height)
                                self.mainBarViewCell.dropShadow()
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.2,
                                           animations: {
                                            self.mainBarViewCell.frame = CGRect(x:self.mainBarViewCell.frame.origin.x, y: self.mainBarViewCell.frame.origin.y + 15, width: self.mainBarViewCell.frame.size.width, height: self.mainBarViewCell.frame.size.height)
                                            
                            },
                                           completion: { _ in
                                            self.indexPathCell = indexPath
                                            self.drinkObj = self.arrDrinks[indexPath.row]
                                            self.mainBarViewCell.removedropShadow()
                                            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
                                            vc.drinkObj = self.arrDrinks[indexPath.row]
                                          
                                            self.navigationController?.pushViewController(vc, animated: true)
                            })
                            
            })
        }
    }
    @objc func viewDetail()
    {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader
        {
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopSectionViewCell", for: indexPath) as! TopSectionViewCell
            return commentView
        }
        else{

            let commentView = UICollectionReusableView.init()
            return commentView
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 2 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
    }
    
    
   
}


