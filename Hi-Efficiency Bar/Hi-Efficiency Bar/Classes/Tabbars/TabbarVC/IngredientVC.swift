//
//  IngredientVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/21/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class IngredientVC: UIViewController {

    @IBOutlet weak var collectionViewMenu: UICollectionView!
    @IBOutlet weak var collectionItem: UICollectionView!
    var arrmenus = [#imageLiteral(resourceName: "ing_1"), #imageLiteral(resourceName: "ing_2"), #imageLiteral(resourceName: "ing_3"), #imageLiteral(resourceName: "ing_4"), #imageLiteral(resourceName: "ing_5"), #imageLiteral(resourceName: "ing_6")]
    var indexSelect = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      self.collectionItem.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
         self.collectionViewMenu.register(UINib(nibName: "IngreCollect", bundle: nil), forCellWithReuseIdentifier: "IngreCollect")
        // Do any additional setup after loading the view.
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
extension IngredientVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionItem {
            return 20
        }
        return arrmenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionItem {
            let cell = collectionItem.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
            return cell
        }
        let cell = collectionViewMenu.dequeueReusableCell(withReuseIdentifier: "IngreCollect", for: indexPath) as! IngreCollect
       cell.imgCell.image = arrmenus[indexPath.row]
        if indexSelect == indexPath.row {
            cell.spaceTop.isHidden = false
            cell.spaceBottom.isHidden = false
        }
        else{
            cell.spaceTop.isHidden = true
            cell.spaceBottom.isHidden = true
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == collectionItem {
            return CGSize(width: (collectionView.frame.size.width - 4)/2, height: 50)
        }
        return CGSize(width: (collectionView.frame.size.width)/6, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionItem {
            return
        }
        indexSelect = indexPath.row
        collectionViewMenu.reloadData()
    }
    
    
}
