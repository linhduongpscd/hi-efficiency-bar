//
//  DetailMainBarVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailMainBarVC: UIViewController {
    var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet weak var collectionView: UICollectionView!
    var mainBarObj = MainBarObj.init(dict: NSDictionary.init())
    var offset = 0
    var isLoadMore = false
    var arrDrinks = [DrinkObj]()
    var refresher:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = mainBarObj.name
        self.collectionView.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        // Do any additional setup after loading the view.
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: collectionView)
        //self.configRefresh()
        self.fetchAllDrinkByCategory()
    }
    
    func configRefresh()
    {
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refresher
        } else {
            self.collectionView!.addSubview(refresher)
        }
        
    }
    @objc func loadData() {
        self.isLoadMore = false
        offset = 0
        ManagerWS.shared.getListDrinkByCategory(categoryID: mainBarObj.id!, offset: offset) { (success, arrs) in
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
       // self.refresher.beginRefreshing()
        ManagerWS.shared.getListDrinkByCategory(categoryID: mainBarObj.id!, offset: offset) { (success, arrs) in
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

}
extension DetailMainBarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
       
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
