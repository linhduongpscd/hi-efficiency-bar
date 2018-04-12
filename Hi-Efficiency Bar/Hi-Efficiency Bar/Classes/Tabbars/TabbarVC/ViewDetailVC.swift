//
//  ViewDetailVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/21/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class ViewDetailVC: HelpController,ASFSharedViewTransitionDataSource {
    @IBOutlet weak var tblDetail: UITableView!
     @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var btnAddMyCard: TransitionButton!
    @IBOutlet weak var lblQuanlity: UILabel!
    var number = 1
    @IBOutlet var subNaviRight: UIView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var constraintBottomFav: NSLayoutConstraint!
    var isFav = false
    @IBOutlet weak var iconCustomize: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var drinkObj = DrinkObj.init(dict: NSDictionary.init())
    var arringredients = NSMutableArray.init()
    var arrGarnish = NSMutableArray.init()
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var tblGarnish: UITableView!
    @IBOutlet weak var heightTblGarnish: NSLayoutConstraint!
    @IBOutlet weak var subIce: UIView!
    @IBOutlet weak var subTitleIce: UIView!
    @IBOutlet weak var heightIce: NSLayoutConstraint!
    @IBOutlet weak var heightTitleIce: NSLayoutConstraint!
    
    @IBOutlet weak var imgNone: UIImageView!
    @IBOutlet weak var lblNone: UILabel!
    @IBOutlet weak var imgSome: UIImageView!
    @IBOutlet weak var lblSome: UILabel!
    @IBOutlet weak var imgNormal: UIImageView!
    @IBOutlet weak var lblNormal: UILabel!
    var valueIce = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
         self.tblDetail.register(UINib(nibName: "CurrentOrderCellNotTimeLine", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
        btnAddMyCard.spinnerColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let btnRight = UIBarButtonItem.init(customView: subNaviRight)
        self.navigationItem.rightBarButtonItem = btnRight
        self.initViewDetail()
    }
    
    func initViewDetail()
    {
        arringredients = drinkObj.ingredients?.mutableCopy() as! NSMutableArray
        for recod in drinkObj.garnishes!
        {
            let dict = recod as! NSDictionary
            let obj = garnish.init(dict: dict)
           
            arrGarnish.add(obj)
            
        }
        if drinkObj.image != nil
        {
            imgDetail.sd_setImage(with: URL.init(string: drinkObj.image!), completed: { (image, error, type, url) in
                
            })
        }
        lblName.text = drinkObj.name
        if drinkObj.is_favorite! {
            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
        }
        else{
            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
        }
        heightTable.constant = CGFloat(arringredients.count * 55)
        heightTblGarnish.constant = CGFloat(arrGarnish.count * 44)
        if drinkObj.is_have_ice!
        {
            subIce.isHidden = false
            subTitleIce.isHidden = false
            heightTitleIce.constant = 35
            heightIce.constant = 100
        }
        else{
            subIce.isHidden = true
            subTitleIce.isHidden = true
            heightTitleIce.constant = 0
            heightIce.constant = 0
        }
        
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none2"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doFav(_ sender: Any) {
        if !drinkObj.is_favorite!
        {
            drinkObj.is_favorite = true
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
                            self.constraintBottomFav.constant = -52
                            self.btnFav.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.25) {
                                self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav2"), for: .normal)
                                self.constraintBottomFav.constant = -37
                                self.btnFav.transform = CGAffineTransform.identity
                            }
            })
        }
        else{
           drinkObj.is_favorite = false
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
                            self.constraintBottomFav.constant = -52
                            self.btnFav.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.25) {
                                self.btnFav.setImage(#imageLiteral(resourceName: "ic_fav1"), for: .normal)
                                self.constraintBottomFav.constant = -37
                                self.btnFav.transform = CGAffineTransform.identity
                            }
            })
        }
        
        ManagerWS.shared.favUnFavDrink(drinkID: drinkObj.id!) { (success) in
            
        }
       
    }
    @IBAction func doCustomize(_ sender: Any) {
        self.iconCustomize.swing {
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CustomDetailVC") as! CustomDetailVC
            vc.drinkObj = self.drinkObj
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
      
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
    @IBAction func doTang(_ sender: Any) {
        number = number + 1
        lblQuanlity.text = "\(number)"
        CommonHellper.animateButton(view: lblQuanlity)
    }
    
    @IBAction func doGiam(_ sender: Any) {
        if number == 1
        {
            
        }
        else{
            number = number - 1
            lblQuanlity.text = "\(number)"
            CommonHellper.animateButton(view: lblQuanlity)
        }
    }
    @IBAction func doAddMyTab(_ sender: TransitionButton) {
        self.addLoadingView()
        btnAddMyCard.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            ManagerWS.shared.addMyTab(para: self.paramAddMyTab(), complete: { (success) in
                if success!
                {
                    self.removeLoadingView()
                    self.btnAddMyCard.setTitle("", for: .normal)
                    self.btnAddMyCard.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                    self.btnAddMyCard.stopAnimation(animationStyle: .shake, completion: {
                        
                        
                    })
                    self.perform(#selector(self.addmyTabSuccess), with: nil, afterDelay: 0.5)
                }
                else{
                    self.btnAddMyCard.setTitle("ADD TO MY TAB", for: .normal)
                    self.btnAddMyCard.stopAnimation(animationStyle: .shake, completion: {
                        self.removeLoadingView()
                    })
                    //self.showAlertMessage(message: "The email is not existed, please try again")
                }
            })
        })
        
    }
    
    @objc func addmyTabSuccess()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func checkValueGarnish()->Bool
    {
        var isCheck = false
        for recod in arrGarnish {
            let obj = recod as! garnish
            if obj.isSwitch!
            {
                isCheck = true
                break
            }
        }
        return isCheck
    }
    
     func arrayparaGarnish()->[Int]
     {
        var arrs = [Int]()
        for recod in arrGarnish {
            let obj = recod as! garnish
            if obj.isSwitch!
            {
                arrs.append(obj.id!)
            }
        }
        return arrs
    }
    func paramAddMyTab()->Parameters
    {
        if self.checkValueGarnish() {
            let para = ["ice": valueIce, "quantity": lblQuanlity.text!, "drink": drinkObj.id!,"garnishes": self.arrayparaGarnish()] as [String : Any]
            return para
        }
        else{
            let para = ["ice": valueIce, "quantity": lblQuanlity.text!, "drink": drinkObj.id!] as [String : Any]
            return para
        }
    }
    
   
    func sharedView() -> UIView! {
        return imgDetail
    }
    
    func setColorTextNormalOrSelect(lable: UILabel, isSelect: Bool)
    {
        if isSelect {
            lable.textColor = COLOR_SELECTED
        }
        else
        {
            lable.textColor = COLOR_NORMAL
        }
    }
    func setImageSeletd(imageView: UIImageView, uimage: UIImage)
    {
        imageView.image = uimage
    }
    @IBAction func doNone(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none2"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
        CommonHellper.animateView(view: imgNone)
        valueIce = 0
    }
    @IBAction func doSome(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none1"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some2"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
        CommonHellper.animateView(view: imgSome)
        valueIce = 10
    }
    @IBAction func doNormal(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: true)
        
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none1"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal2"))
        CommonHellper.animateView(view: imgNormal)
        valueIce = 20
    }
}
extension ViewDetailVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblGarnish
        {
            return arrGarnish.count
        }
        return arringredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblGarnish
        {
            return 44
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblGarnish
        {
            let cell = self.tblGarnish.dequeueReusableCell(withIdentifier: "GarnishCell") as! GarnishCell
            self.configCellGarnish(cell, garnishObj: arrGarnish[indexPath.row] as! garnish)
            return cell
        }
        let cell = self.tblDetail.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
       if indexPath.row == 2
       {
            //cell.subContent.backgroundColor = UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
       }
       else{
            cell.subContent.backgroundColor = UIColor.white
        }
        cell.backgroundColor = UIColor.clear
        self.configCell(cell, dict: arringredients[indexPath.row] as! NSDictionary)
        return cell
    }
    
    func configCell(_ cell: CurrentOrderCell, dict: NSDictionary)
    {
        cell.lblPart.text = "\(dict.object(forKey: "ratio") as! Int) \(dict.object(forKey: "unit") as! String)"
        if let val = dict.object(forKey: "ingredient") as? NSDictionary
        {
            if let name = val.object(forKey: "name") as? String
            {
                 cell.lblName.text = name
            }
        }
       
    }
    
    func configCellGarnish(_ cell: GarnishCell, garnishObj: garnish)
    {
         cell.lblName.text = garnishObj.name
        cell.btnSwitch.isOn = garnishObj.isSwitch!
        
    }
}

