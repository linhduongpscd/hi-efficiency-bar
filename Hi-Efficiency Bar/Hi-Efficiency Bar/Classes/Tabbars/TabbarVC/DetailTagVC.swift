//
//  DetailTagVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailTagVC: UIViewController, ASFSharedViewTransitionDataSource {

    @IBOutlet weak var collectionResult: UICollectionView!
    var stringTag = String()
    var arrIngredient = [Ingredient]()
    var offsetIngredient = 0
    var isLoadMoreIngredient = false
    
    var arrDrinks = [DrinkObj]()
    var offsetDrink = 0
    var isLoadMoreDrink = false
    
    var arrgenres = [GenreObj]()
    
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ASFSharedViewTransition.addWith(fromViewControllerClass: DetailTagVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
        self.collectionResult.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.collectionResult.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.collectionResult.register(UINib(nibName: "DetailCockTailCollect", bundle: nil), forCellWithReuseIdentifier: "DetailCockTailCollect")
         self.collectionResult.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")
        self.collectionResult.register(UINib(nibName: "FooterDetailTag", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterDetailTag")
        
        self.navigationItem.title = "Result for \(stringTag)"
        offsetIngredient = 0
        self.fechingredientSearch()
        self.fecthSearchByCategory()
        self.fechDrinkSearch()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fechingredientSearch()
    {
        CommonHellper.showBusy()
        ManagerWS.shared.getSearchIngredient(txtSearch: stringTag, offset: offsetIngredient) { (success, arrs) in
            
            if arrs!.count > 0 && arrs!.count >= kLimitPage
            {
                self.isLoadMoreIngredient = true
            }
            else{
                self.isLoadMoreIngredient = false
            }
            for item in arrs!
            {
                self.arrIngredient.append(item)
            }
            self.collectionResult.reloadData()
             CommonHellper.hideBusy()
        }
    }
    
    func fecthSearchByCategory()
    {
        ManagerWS.shared.getSearchDrinkByCategory(txtSearch: stringTag, offset: 0) { (success, arrs) in
            self.arrgenres = arrs!
             self.collectionResult.reloadData()
        }
    }
    
    func fechDrinkSearch()
    {
        ManagerWS.shared.getSearchDrink(txtSearch: stringTag, offset: offsetDrink) { (succ, arrs) in
            
            if arrs!.count > 0 && arrs!.count >= kLimitPage
            {
                self.isLoadMoreDrink = true
            }
            else{
                self.isLoadMoreDrink = false
            }
            for item in arrs!
            {
                self.arrDrinks.append(item)
            }
            self.collectionResult.reloadData()
             CommonHellper.hideBusy()
        }
    }
    func sharedView() -> UIView! {
        let cell = collectionResult.cellForItem(at: (collectionResult.indexPathsForSelectedItems?.first)!) as! MainBarViewCell
        if cell.drinkObj.is_favorite!
        {
            cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
        }
        else{
            cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
        }
        return cell.imgCell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailTagVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.arrIngredient.count
        }
        if section == 1 {
            return self.arrgenres.count
        }
        return self.arrDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0
        {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
            cell.subContent.backgroundColor = UIColor.white
            cell.lbltext.textColor = UIColor.black
            let ingreObj = self.arrIngredient[indexPath.row]
            cell.lbltext.text = ingreObj.name
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCockTailCollect", for: indexPath) as! DetailCockTailCollect
            if indexPath.row % 2 == 0 {
                cell.spaceRight.isHidden = false
                
            }
            else{
                cell.spaceRight.isHidden = true
            }
            let obj = arrgenres[indexPath.row]
            cell.lblName.text = obj.name
            if obj.image != nil
            {
                cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                    
                })
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
        cell.configCell(drinkObj: arrDrinks[indexPath.row])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
             return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 50)
        }
        if indexPath.section == 1 {
           return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 185)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
            vc.isIngredient = true
            vc.ingredientObj = arrIngredient[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1
        {
            let genereObj = arrgenres[indexPath.row]
            let obj = MainBarObj.init(dict: NSDictionary.init())
            obj.id = genereObj.id
            obj.name = genereObj.name
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
            vc.mainBarObj = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 2
        {
            mainBarViewCell = self.collectionResult.cellForItem(at: indexPath) as! MainBarViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader
        {
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopSectionViewCell", for: indexPath) as! TopSectionViewCell
            if indexPath.section == 0
            {
                commentView.lblTitle.text = "Ingredients"
            }
            else if indexPath.section == 1
            {
                commentView.lblTitle.text = "Genere"
            }
            else{
                commentView.lblTitle.text = "Cocktails"
            }
            return commentView
        }
        else{
          let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterDetailTag", for: indexPath) as! FooterDetailTag
            if indexPath.section == 0
            {
                commentView.tapLoadMore = {[] in
                    self.offsetIngredient = self.offsetIngredient + kLimitPage
                    self.fechingredientSearch()
                }
            }
            if indexPath.section == 2
            {
                commentView.tapLoadMore = {[] in
                    self.offsetDrink = self.offsetDrink + kLimitPage
                    self.fechDrinkSearch()
                }
            }
            else{
                
            }
            return commentView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0
        {
            if isLoadMoreIngredient
            {
                 return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
            }
            else{
                 return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            }
        }
        else if section == 1
        {
           return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        }
        else{
            if isLoadMoreDrink
            {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
            }
            else{
                return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            }
        }
    }
}
