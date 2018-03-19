//
//  DetailCocktailVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailCocktailVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "DetailCockTailCollect", bundle: nil), forCellWithReuseIdentifier: "DetailCockTailCollect")
     
         self.collectionView.register(UINib(nibName: "DetailHeaderGenereCollect", bundle: nil), forCellWithReuseIdentifier: "DetailHeaderGenereCollect")
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
extension DetailCocktailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailHeaderGenereCollect", for: indexPath) as! DetailHeaderGenereCollect
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCockTailCollect", for: indexPath) as! DetailCockTailCollect
        if indexPath.row % 2 == 0 {
            cell.spaceRight.isHidden = true
            
        }
        else{
          cell.spaceRight.isHidden = false
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 305)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 185)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    
}
