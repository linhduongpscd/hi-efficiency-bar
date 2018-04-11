//
//  SearchTagVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 30/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SearchTagVC: UIViewController {

    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var collectionSearch: UICollectionView!
    var arrDrinks = [DrinkObj]()
    var offset = 0
    var isLoadMore = false
    var indexPathCell: IndexPath?
    var mainBarViewCell = MainBarViewCell.init(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        txfSearch.becomeFirstResponder()
        self.collectionSearch.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchAllDrink()
    {
        ManagerWS.shared.getSearchDrink(txtSearch: CommonHellper.trimSpaceString(txtString: txfSearch.text!), offset: offset) { (success, arrs) in
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
            self.collectionSearch.reloadData()
        }
    }
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}
extension SearchTagVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.arrDrinks.removeAll()
        offset = 0
        isLoadMore = false
        self.fetchAllDrink()
        return true
    }
}
extension SearchTagVC: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        txfSearch.resignFirstResponder()
    }
}
extension SearchTagVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return arrDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
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
        
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainBarViewCell = self.collectionSearch.cellForItem(at: indexPath) as! MainBarViewCell
        // CommonHellper.animateViewSmall(view: mainBarViewCell)
        //self.perform(#selector(self.viewDetail), with: nil, afterDelay: 0.8)
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
                                        self.mainBarViewCell.removedropShadow()
                                        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
                                        vc.drinkObj = self.arrDrinks[indexPath.row]
                                        
                                        self.navigationController?.pushViewController(vc, animated: true)
                        })
                        
        })
    }
}
