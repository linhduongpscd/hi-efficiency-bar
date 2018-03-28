//
//  SearchVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var stringTag = ""
     let arrDatas = ["Cocktail Type", "Base Spirit", "Cocktail Strength", "Cocktail Color", "Around The World", "Moments", "Mood & Style", "Celebrations"]
    var isQuickSearch = true
    var isSearchIngre = false
    var isSearchGenre = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.collectionView.register(UINib(nibName: "QuickSearchCollect", bundle: nil), forCellWithReuseIdentifier: "QuickSearchCollect")
        self.collectionView.register(UINib(nibName: "HeaderSearchReusable", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderSearchReusable")
        self.collectionView.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.collectionView.register(UINib(nibName: "MenuSearchCollect", bundle: nil), forCellWithReuseIdentifier: "MenuSearchCollect")
         self.collectionView.register(UINib(nibName: "SearchGenereCollect", bundle: nil), forCellWithReuseIdentifier: "SearchGenereCollect")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
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

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            if isQuickSearch
            {
                return 1
            }
            return 0
        }
        if section == 1 {
            if isSearchIngre
            {
                return 20
            }
            return 0
        }
        if isSearchGenre
        {
            return self.arrDatas.count
        }
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickSearchCollect", for: indexPath) as! QuickSearchCollect
            cell.taptags = { [weak self] in
                let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailTagVC") as! DetailTagVC
                vc.stringTag = cell.stringTag
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSearchCollect", for: indexPath) as! MenuSearchCollect
                cell.registerCell()
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchGenereCollect", for: indexPath) as! SearchGenereCollect
        cell.lblName.text = self.arrDatas[indexPath.row]
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 287)
        }
        if indexPath.section == 1 {
            if indexPath.row == 0
            {
                return CGSize(width: collectionView.frame.size.width, height: 50)
            }
             return CGSize(width: (collectionView.frame.size.width - 4)/2, height: 50)
        }
        
        return CGSize(width:( UIScreen.main.bounds.size.width - 10)/2, height:  170)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if indexPath.section == 2
       {
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailCocktailVC") as! DetailCocktailVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSearchReusable", for: indexPath) as! HeaderSearchReusable
        if indexPath.section == 0 {
            commentView.lblTitle.text = "Quick Search"
        }
        else if indexPath.section == 1
        {
             commentView.lblTitle.text = "Search by ingredient"
        }
        else{
            commentView.lblTitle.text = "Search by Genere"
        }
       commentView.tapSectionSearch = { [weak self] in
            if indexPath.section == 0
            {
                
                  self?.isQuickSearch = !(self?.isQuickSearch)!
                    self?.isSearchGenre = false
                    self?.isSearchIngre = false
                
            }
            else if indexPath.section == 1
            {
                self?.isQuickSearch = false
                self?.isSearchGenre = false
                self?.isSearchIngre = true
            }
            else{
                self?.isQuickSearch = false
                self?.isSearchGenre = true
                self?.isSearchIngre = false
            }
         self?.collectionView.reloadData()
        }
        return commentView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if isQuickSearch
            {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            }
            return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
    }
    
}
/*
extension SearchVC: TagsDelegate{
    
    // Tag Touch Action
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        CommonHellper.animateViewSmall(view: tagButton)
        stringTag = self.tagViews.tagTextArray[tagButton.index]
         self.perform(#selector(self.viewDetail), with: nil, afterDelay: 0.8)
    }
    
    @objc func viewDetail()
    {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailTagVC") as! DetailTagVC
        vc.stringTag = stringTag
        self.navigationController?.pushViewController(vc, animated: true)

    }
    // Last Tag Touch Action
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
        
    }
    
    // TagsView Change Height
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
        
    }
}
extension SearchVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfSearch.resignFirstResponder()
        return true
    }
}
 */
