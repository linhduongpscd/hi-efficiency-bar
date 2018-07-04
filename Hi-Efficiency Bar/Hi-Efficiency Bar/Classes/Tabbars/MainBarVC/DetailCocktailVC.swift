//
//  DetailCocktailVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DetailCocktailVC: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var genereObj = GenreObj.init(dict: NSDictionary.init())
    var arrGeneres = [GenreObj]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(DetailCocktailVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        // refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing please wait...", attributes: attributes)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "DetailCockTailCollect", bundle: nil), forCellWithReuseIdentifier: "DetailCockTailCollect")
     
         self.collectionView.register(UINib(nibName: "DetailHeaderGenereCollect", bundle: nil), forCellWithReuseIdentifier: "DetailHeaderGenereCollect")
        self.navigationItem.title = genereObj.name
        self.fectSubAllgenere(true)
        self.collectionView.addSubview(refreshControl)
        //  self.configHideNaviScroll(collectionView)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        super.viewWillAppear(animated)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        fectSubAllgenere(false)
    }
    func fectSubAllgenere(_ isLoading: Bool)
    {
        if isLoading
        {
            // CommonHellper.showBusy()
        }
        ManagerWS.shared.getSubCategoryByParentID(parentID: genereObj.id!) { (success, arrs) in
             CommonHellper.hideBusy()
            self.refreshControl.endRefreshing()
            self.arrGeneres = arrs!
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension DetailCocktailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return self.arrGeneres.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailHeaderGenereCollect", for: indexPath) as! DetailHeaderGenereCollect
            cell.lblName.text = genereObj.name
            if genereObj.image != nil
            {
                
                    if let imageurl = URL.init(string: self.genereObj.image!)
                    {
                        let name = imageurl.lastPathComponent
                        if name.lowercased().contains("gif")
                        {
                            DispatchQueue.main.async {
                                let imageURL = UIImage.gifImageWithURL(self.genereObj.image!)
                                cell.imgCell.image = imageURL
                            }
                            
                            
                        }
                        else{
                            cell.imgCell.sd_setImage(with: URL.init(string: self.genereObj.image!), completed: { (image, error, type, url) in
                                var fram = cell.imgCell.frame
                                fram.origin.y = fram.origin.y - 15
                                cell.imgCell.frame =  fram
                            })
                        }
                    }
                    else{
                        cell.imgCell.sd_setImage(with: URL.init(string: self.genereObj.image!), completed: { (image, error, type, url) in
                            
                        })
                    }
                }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCockTailCollect", for: indexPath) as! DetailCockTailCollect
        if indexPath.row % 2 == 0 {
            cell.spaceRight.isHidden = true
            
        }
        else{
          cell.spaceRight.isHidden = false
        }
        let obj = arrGeneres[indexPath.row - 1]
        cell.lblName.text = obj.name
        if obj.image != nil
        {
            cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                
            })
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let genereObj = arrGeneres[indexPath.row - 1]
            let obj = MainBarObj.init(dict: NSDictionary.init())
            obj.id = genereObj.id
            obj.name = genereObj.name
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "DetailMainBarVC") as! DetailMainBarVC
            vc.mainBarObj = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 253)
        }
        return CGSize(width: (collectionView.frame.size.width - 2)/2, height: 185)
    }
    
}
