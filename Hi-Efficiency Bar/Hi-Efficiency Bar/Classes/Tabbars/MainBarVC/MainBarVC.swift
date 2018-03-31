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
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    
    
    override func viewDidLoad() {
          ASFSharedViewTransition.addWith(fromViewControllerClass: MainBarVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
        //self.navigationItem.title = "Main Bar"
        
        self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
     self.collectionView.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")
          self.collectionView.register(UINib(nibName: "FooterMainBarCollect", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterMainBarCollect")
       self.configHideNaviScroll(collectionView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    func sharedView() -> UIView! {
        let cell = collectionView.cellForItem(at: (collectionView.indexPathsForSelectedItems?.first)!) as! MainBarViewCell
        return cell.imgCell
    }
}



extension MainBarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderViewCell", for: indexPath) as! HeaderViewCell
            cell.initRegisterCollect()
            cell.tapHeaderMainBar = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
        if indexPath.row % 2 == 0 {
             cell.leaningSubX.constant = 0.0
        }
        else{
            cell.leaningSubX.constant = 5.0
        }
        return cell
     
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
                CommonHellper.animateViewSmall(view: mainBarViewCell.contentView)
                self.perform(#selector(self.viewDetail), with: nil, afterDelay: 0.8)
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
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterMainBarCollect", for: indexPath) as! FooterMainBarCollect
            commentView.tapShowMore = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
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
            return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
    }
}

