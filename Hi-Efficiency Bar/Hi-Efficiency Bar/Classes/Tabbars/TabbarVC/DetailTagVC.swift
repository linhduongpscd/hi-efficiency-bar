//
//  DetailTagVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailTagVC: UIViewController {

    @IBOutlet weak var collectionResult: UICollectionView!
    var stringTag = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionResult.register(UINib(nibName: "MainBarViewCell", bundle: nil), forCellWithReuseIdentifier: "MainBarViewCell")
        self.collectionResult.register(UINib(nibName: "IngreItemCollect", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.collectionResult.register(UINib(nibName: "DetailCockTailCollect", bundle: nil), forCellWithReuseIdentifier: "DetailCockTailCollect")
         self.collectionResult.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")
        self.navigationItem.title = "Result for \(stringTag)"
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
            return 2
        }
        if section == 1 {
            return 1
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0
        {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
            if indexPath.row == 1
            {
                cell.subContent.backgroundColor = UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
            }
            else{
                cell.subContent.backgroundColor = UIColor.white
            }
            cell.lbltext.textColor = UIColor.black
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
             return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 50)
        }
        if indexPath.section == 1 {
           return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 185)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height:  (collectionView.frame.size.width - 2)/2 + 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 1 {
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
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
                commentView.lblTitle.text = "Genre"
            }
            else{
                commentView.lblTitle.text = "Cocktails"
            }
            return commentView
        }
        else{
            let commentView = UICollectionReusableView.init()
            return commentView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 0)
    }
}
