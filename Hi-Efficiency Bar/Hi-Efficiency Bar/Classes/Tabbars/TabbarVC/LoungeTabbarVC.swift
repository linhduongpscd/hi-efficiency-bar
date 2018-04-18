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
class LoungeTabbarVC: BaseViewController, ASFSharedViewTransitionDataSource {
    var profileView = ProfileView.init(frame: .zero)
    @IBOutlet weak var collectionView: UICollectionView!
     var imagePicker: UIImagePickerController!
    @IBOutlet weak var subNavi: UIView!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    @IBOutlet weak var lblNavi: UILabel!
    var isChangeAvatar = Bool()
    var offset = 0
    var isLoadMore = false
    var arrDrinks = [DrinkObj]()
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
            ASFSharedViewTransition.addWith(fromViewControllerClass: LoungeTabbarVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
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
        self.fetchProfile()
        
        // Do any additional setup after loading the view.
    }
    func fetchAllDrink(isIndicator: Bool)
    {
        if isIndicator
        {
            self.arrDrinks.removeAll()
            CommonHellper.showBusy()
        }
        
        ManagerWS.shared.getListFavDrinks(offset: offset) { (success, arrs) in
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
    func fetchProfile()
    {
        ManagerWS.shared.getProfile { (success, info) in
            print(info)
            if let avatar = info.object(forKey: "avatar_url") as? String
            {
                self.profileView.imgAvatar.sd_setImage(with: URL.init(string: avatar), completed: { (image, error, type, url) in
                    self.profileView.imgAvatar.layer.cornerRadius =  self.profileView.imgAvatar.frame.size.width/2
                    self.profileView.imgAvatar.layer.masksToBounds = true
                    self.isChangeAvatar = true
                })
            }
            if let first_name = info.object(forKey: "first_name") as? String
            {
                self.profileView.lblName.text = first_name
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        offset = 0
        self.fetchAllDrink(isIndicator: true)
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
        profileView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 190)
        profileView.tapChangeAvatar = { [] in
            let alert = UIAlertController(title: APP_NAME,
                                          message: nil,
                                          preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let takePhoto = UIAlertAction.init(title: "Take a Photo", style: .default) { (action) in
                self .showCamera()
            }
            
            alert.addAction(takePhoto)
            
            let selectPhoto = UIAlertAction.init(title: "Select a Photo", style: .default) { (action) in
                self .showLibrary()
            }
            
            alert.addAction(selectPhoto)
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        collectionView.parallaxHeader.delegate = self
        collectionView.parallaxHeader.view = profileView
        collectionView.parallaxHeader.height = 190
        collectionView.parallaxHeader.mode = .fill
        
    }
    func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func sharedView() -> UIView! {
        let cell = collectionView.cellForItem(at: (collectionView.indexPathsForSelectedItems?.first)!) as! MainBarViewCell
       
        return cell.imgCell
    }
}
extension LoungeTabbarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            profileView.imgAvatar.layer.cornerRadius = profileView.imgAvatar.frame.size.width/2
            profileView.imgAvatar.layer.masksToBounds = true
           profileView.imgAvatar.image = image
            isChangeAvatar = true
        }
        self.dismiss(animated: true) {
            
        }
    }
}
extension LoungeTabbarVC: MXParallaxHeaderDelegate
{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(parallaxHeader.progress)
        print(profileView)
        self.subNavi.alpha = 1 - parallaxHeader.progress
        if parallaxHeader.progress > 0.0
        {
            self.lblNavi.text = "My Lounge"
            self.lblNavi.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: 20.0)
        }
        else{
            //self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "white"), for: .default)
            // self.navigationItem.title = "Ryan Hoover"
             self.lblNavi.text = self.profileView.lblName.text
            //rprofileView.constrantAvatar.constant = parallaxHeader.progress
             self.lblNavi.font = UIFont.init(name: FONT_APP.AlrightSans_Medium, size: 20.0)
        }
        if isChangeAvatar {
            let value = Float(parallaxHeader.progress)
            profileView.constaintAvatar.constant = CGFloat(value)
            print(profileView.constaintAvatar.constant)
            profileView.imgAvatar.layer.cornerRadius = profileView.imgAvatar.frame.size.width/2
            profileView.imgAvatar.layer.masksToBounds = true
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
        return self.arrDrinks.count
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
        cell.isMyFav = true
        cell.indexPathCell = indexPath
        cell.configCell(drinkObj: self.arrDrinks[indexPath.row])
        cell.tapUnFavDrink = {[] in
             //print(cell.indexPathCell?.row)
            self.arrDrinks.remove(at: (cell.indexPathCell?.row)!)
             self.collectionView.reloadData()
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
                                            self.mainBarViewCell.removedropShadow()
                                            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
                                            vc.drinkObj = self.arrDrinks[indexPath.row]
                                            
                                            self.navigationController?.pushViewController(vc, animated: true)
                            })
                            
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isLoadMore && self.arrDrinks.count/2 == indexPath.row - 1 {
            print("VAO DAY")
            isLoadMore = false
            self.offset = self.offset + kLimitPage
            self.fetchAllDrink(isIndicator: false)
        }
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
