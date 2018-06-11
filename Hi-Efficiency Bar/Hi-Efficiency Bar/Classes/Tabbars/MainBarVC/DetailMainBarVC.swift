//
//  DetailMainBarVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailMainBarVC: UIViewController, ASFSharedViewTransitionDataSource {
    var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet weak var collectionView: UICollectionView!
    var mainBarObj = MainBarObj.init(dict: NSDictionary.init())
    var offset = 0
    var isLoadMore = false
    var arrDrinks = [DrinkObj]()
    var refresher:UIRefreshControl!
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    var isIngredient = false
    var ingredientObj = Ingredient.init(dict: NSDictionary.init())
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(DetailMainBarVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        // refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing please wait...", attributes: attributes)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        ASFSharedViewTransition.addWith(fromViewControllerClass: DetailMainBarVC.self, toViewControllerClass: ViewDetailVC.self, with: self.navigationController, withDuration: 0.3)
        if isIngredient
        {
            self.navigationItem.title = ingredientObj.name
        }
        else{
            self.navigationItem.title = mainBarObj.name
        }
        
        self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
            self.collectionView.register(UINib(nibName: "NoDataCollect", bundle: nil), forCellWithReuseIdentifier: "NoDataCollect")
        // Do any additional setup after loading the view.
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: collectionView)
        //self.configRefresh()
        collectionView.isHidden = true
        collectionView.addSubview(refreshControl)
        
        self.fetchAllDrinkByCategory()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        offset = 0
        isLoadMore = false
        self.fetchAllDrinkByCategory()
    }
    
    @objc func loadData() {
        self.isLoadMore = false
        offset = 0
        if isIngredient
        {
            ManagerWS.shared.getListDrinkByingredient(ingredientID: ingredientObj.id!, offset: offset) { (success, arrs) in
                
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
        else{
            ManagerWS.shared.getListDrinkByCategory(categoryID: mainBarObj.id!, offset: offset) { (success, arrs) in
                
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
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    func fetchAllDrinkByCategory()
    {
        if isIngredient
        {
             ManagerWS.shared.getListDrinkByingredient(ingredientID: ingredientObj.id!, offset: offset) { (success, arrs) in
                self.refreshControl.endRefreshing()
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
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
        else{
            ManagerWS.shared.getListDrinkByCategory(categoryID: mainBarObj.id!, offset: offset) { (success, arrs) in
                self.refreshControl.endRefreshing()
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
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
        
    }
    
    // MARK: UITableViewDelegate
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func sharedView() -> UIView! {
        let cell = collectionView.cellForItem(at: (collectionView.indexPathsForSelectedItems?.first)!) as! MainBarViewCell
        if cell.drinkObj.is_favorite!
        {
            cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
        }
        else{
            cell.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
        }
          cell.imgCell.isHidden = true
        return cell.imgCell
    }
}
extension DetailMainBarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrDrinks.count == 0
        {
            return 1
        }
        return arrDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrDrinks.count == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCollect", for: indexPath) as! NoDataCollect
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBarViewCell", for: indexPath) as! MainBarViewCell
        if indexPath.row % 2 == 0 {
            cell.leaningSubX.constant = 0.0
        }
        else{
            cell.leaningSubX.constant = 5.0
        }
        cell.configCell(drinkObj: self.arrDrinks[indexPath.row])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       if arrDrinks.count == 0
       {
            return CGSize(width: collectionView.frame.size.width, height:  100)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrDrinks.count > 0
        {
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
            self.fetchAllDrinkByCategory()
        }
    }
    
}
