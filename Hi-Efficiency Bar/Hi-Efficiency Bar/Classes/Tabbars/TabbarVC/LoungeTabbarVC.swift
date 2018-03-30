//
//  LoungeTabbarVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 28/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

import UIKit
import MXParallaxHeader
class LoungeTabbarVC: UIViewController {
    var profileView = ProfileView.init(frame: .zero)
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subNavi: UIView!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.collectionView.register(UINib(nibName: "TopLoungeCollect", bundle: nil), forCellWithReuseIdentifier: "TopLoungeCollect")
        self.collectionView.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")

        self.initParalax()
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("iPhone X")
                heightNavi.constant = 84
            default:
                print("unknown")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initParalax()
    {
        profileView = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?[0] as! ProfileView
        profileView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 192)
        collectionView.parallaxHeader.delegate = self
        collectionView.parallaxHeader.view = profileView
        collectionView.parallaxHeader.height = 192
        collectionView.parallaxHeader.mode = .fill
        
    }
    
}

extension LoungeTabbarVC: MXParallaxHeaderDelegate
{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(parallaxHeader.progress)
       self.subNavi.alpha = 1 - parallaxHeader.progress
        if parallaxHeader.progress > 0.0
        {
            //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            //self.navigationItem.title = "My Lounge"
            self.lblNavi.text = "My Lounge"
            self.lblNavi.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: 20.0)
        }
        else{
            //self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "white"), for: .default)
            // self.navigationItem.title = "Ryan Hoover"
             self.lblNavi.text = "Ryan Hoover"
             self.lblNavi.font = UIFont.init(name: FONT_APP.AlrightSans_Medium, size: 20.0)
        }
    }
}
extension LoungeTabbarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopLoungeCollect", for: indexPath) as! TopLoungeCollect
            cell.tapPreOrder = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "PreOrderVC") as! PreOrderVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.tapCurrentOrder = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
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
        if indexPath.section == 0
        {
            return CGSize(width: collectionView.frame.size.width, height: 190)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader
        {
            if indexPath.section == 0
            {
                let view = UICollectionReusableView.init(frame: .zero)
                return view
            }
            else{
                let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopSectionViewCell", for: indexPath) as! TopSectionViewCell
                commentView.lblTitle.text = "My Favourites"
                return commentView
            }
            
        }
        else{
            let view = UICollectionReusableView.init(frame: .zero)
            return view
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0
        {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        else{
            return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
    }
}
