//
//  CustomDetailVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class CustomDetailVC: UIViewController {

    @IBOutlet weak var tblDetail: UITableView!
    @IBOutlet weak var btnAddCustom: TransitionButton!
    @IBOutlet weak var imgDrink: UIImageView!
    @IBOutlet weak var imgShot: UIImageView!
    @IBOutlet weak var lblShot: UILabel!
    @IBOutlet weak var imgShort: UIImageView!
    @IBOutlet weak var lblShort: UILabel!
    @IBOutlet weak var imgWine: UIImageView!
    @IBOutlet weak var lblWine: UILabel!
    @IBOutlet weak var imgTail: UIImageView!
    @IBOutlet weak var lblTail: UILabel!
    @IBOutlet weak var imgMartine: UIImageView!
    @IBOutlet weak var lblMartine: UILabel!
    //
    @IBOutlet weak var imgShake: UIImageView!
    @IBOutlet weak var lblShake: UILabel!
    @IBOutlet weak var imgFilter: UIImageView!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var imgStir: UIImageView!
    @IBOutlet weak var lblStir: UILabel!
    @IBOutlet weak var imgMuddle: UIImageView!
    @IBOutlet weak var lblMuddle: UILabel!
    @IBOutlet weak var imgNone: UIImageView!
    @IBOutlet weak var lblNone: UILabel!
    @IBOutlet weak var imgSome: UIImageView!
    @IBOutlet weak var lblSome: UILabel!
    @IBOutlet weak var imgNormal: UIImageView!
    @IBOutlet weak var lblNormal: UILabel!
    @IBOutlet weak var lblQuanlity: UILabel!
    var numberQuanlity = 1
    var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet weak var scrollPage: UIScrollView!
    @IBOutlet var subNaviRight: UIView!
    @IBOutlet weak var btnActionRight: UIButton!
    @IBOutlet weak var imgRorate: UIImageView!
    @IBOutlet weak var txfDrinkName: UITextField!
    @IBOutlet weak var widthTxfDrinkName: NSLayoutConstraint!
    @IBOutlet weak var btnEditName: UIButton!
    var isEditName = false
    @IBOutlet weak var leaningBtnName: NSLayoutConstraint!
    @IBOutlet weak var collectionLy: UICollectionView!
    var arrLys = [GlassObj]()
    @IBOutlet weak var lblMaxSize: UILabel!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    var drinkObj = DrinkObj.init(dict: NSDictionary.init())
    var arringredients = NSMutableArray.init()
    var prep = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddCustom.spinnerColor = .white
        self.setDefault()
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollPage)
        let btnRight = UIBarButtonItem.init(customView: subNaviRight)
        self.navigationItem.rightBarButtonItem = btnRight
        txfDrinkName.isEnabled = false
        self.fectAllGlass()
        self.initData()
    }
    
    func initData()
    {
        print(drinkObj.ingredients)
         arringredients = drinkObj.ingredients?.mutableCopy() as! NSMutableArray
        heightTable.constant = CGFloat(arringredients.count * 44)
        txfDrinkName.text = drinkObj.name
        tblDetail.reloadData()
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
    
    // MARK: UITableViewDelegate
    
    func fectAllGlass()
    {
        ManagerWS.shared.getListAllGlass { (success, arrs) in
            self.arrLys = arrs!
            self.collectionLy.reloadData()
            if self.arrLys.count > 0
            {
                let obj = self.arrLys[0]
                if obj.image != nil{
                    self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                        self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                        self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                    })
                }
                self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
            }
            else{
                 self.lblMaxSize.text = ""
            }
        }
    }
    @IBAction func doEditName(_ sender: Any) {
        if !isEditName {
            txfDrinkName.isEnabled = true
            isEditName = true
            
            UIView.animate(withDuration: 0.25, animations: {
                self.widthTxfDrinkName.constant = UIScreen.main.bounds.size.width - 180
                self.leaningBtnName.constant = -(UIScreen.main.bounds.size.width - 180) - 14
            }, completion: { (success) in
                self.txfDrinkName.becomeFirstResponder()
            })
        }
    }
    
    @IBAction func doRightNavi(_ sender: Any) {
        CATransaction.begin()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = 0.4
        rotationAnimation.repeatCount = 1
        
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
            rotationAnimation.duration = 0.4
            rotationAnimation.repeatCount = 1
            
            CATransaction.setCompletionBlock {
            }
            self.imgRorate.layer.add(rotationAnimation, forKey: nil)
            CATransaction.commit()
        }
        self.imgRorate.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
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
    
    func setDefault()
    {
       
        self.setColorTextNormalOrSelect(lable: lblShake, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblFilter, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblStir, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMuddle, isSelect: false)
        setImageSeletd(imageView: imgShake, uimage: #imageLiteral(resourceName: "prep_shake2"))
        setImageSeletd(imageView: imgFilter, uimage: #imageLiteral(resourceName: "prep_filter1"))
        setImageSeletd(imageView: imgStir, uimage: #imageLiteral(resourceName: "prep_stir1"))
        setImageSeletd(imageView: imgMuddle, uimage: #imageLiteral(resourceName: "prep_muddle1"))
        
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none2"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
    }
    @IBAction func doShot(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: false)
        
        self.setImageSeletd(imageView: imgShot, uimage: #imageLiteral(resourceName: "size_shot2"))
        self.setImageSeletd(imageView: imgShort, uimage: #imageLiteral(resourceName: "size_short1"))
        setImageSeletd(imageView: imgWine, uimage: #imageLiteral(resourceName: "size_wine1"))
        setImageSeletd(imageView: imgTail, uimage: #imageLiteral(resourceName: "size_tail1"))
        setImageSeletd(imageView: imgMartine, uimage: #imageLiteral(resourceName: "size_martini1"))
        imgDrink.image = #imageLiteral(resourceName: "big_shot")
        CommonHellper.animateView(view: imgShot)
    }
    @IBAction func doShort(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: false)
        self.setImageSeletd(imageView: imgShot, uimage: #imageLiteral(resourceName: "size_shot1"))
        self.setImageSeletd(imageView: imgShort, uimage: #imageLiteral(resourceName: "size_short2"))
        setImageSeletd(imageView: imgWine, uimage: #imageLiteral(resourceName: "size_wine1"))
        setImageSeletd(imageView: imgTail, uimage: #imageLiteral(resourceName: "size_tail1"))
        setImageSeletd(imageView: imgMartine, uimage: #imageLiteral(resourceName: "size_martini1"))
        imgDrink.image = #imageLiteral(resourceName: "big_short")
        CommonHellper.animateView(view: imgShort)
    }
    @IBAction func doWine(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: false)
        
        self.setImageSeletd(imageView: imgShot, uimage: #imageLiteral(resourceName: "size_shot1"))
        self.setImageSeletd(imageView: imgShort, uimage: #imageLiteral(resourceName: "size_short1"))
        setImageSeletd(imageView: imgWine, uimage: #imageLiteral(resourceName: "size_wine2"))
        setImageSeletd(imageView: imgTail, uimage: #imageLiteral(resourceName: "size_tail1"))
        setImageSeletd(imageView: imgMartine, uimage: #imageLiteral(resourceName: "size_martini1"))
        imgDrink.image = #imageLiteral(resourceName: "big_wine")
        CommonHellper.animateView(view: imgWine)
    }
    @IBAction func doTail(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: false)
        self.setImageSeletd(imageView: imgShot, uimage: #imageLiteral(resourceName: "size_shot1"))
        self.setImageSeletd(imageView: imgShort, uimage: #imageLiteral(resourceName: "size_short1"))
        setImageSeletd(imageView: imgWine, uimage: #imageLiteral(resourceName: "size_wine1"))
        setImageSeletd(imageView: imgTail, uimage: #imageLiteral(resourceName: "size_tail2"))
        setImageSeletd(imageView: imgMartine, uimage: #imageLiteral(resourceName: "size_martini1"))
        imgDrink.image = #imageLiteral(resourceName: "big_tall")
        CommonHellper.animateView(view: imgTail)
    }
    @IBAction func doMartini(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: true)
        
        self.setColorTextNormalOrSelect(lable: lblShot, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblShort, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblWine, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblTail, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblMartine, isSelect: false)
        self.setImageSeletd(imageView: imgShot, uimage: #imageLiteral(resourceName: "size_shot1"))
        self.setImageSeletd(imageView: imgShort, uimage: #imageLiteral(resourceName: "size_short1"))
        setImageSeletd(imageView: imgWine, uimage: #imageLiteral(resourceName: "size_wine1"))
        setImageSeletd(imageView: imgTail, uimage: #imageLiteral(resourceName: "size_tail1"))
        setImageSeletd(imageView: imgMartine, uimage: #imageLiteral(resourceName: "size_martini2"))
        imgDrink.image = #imageLiteral(resourceName: "big_martini")
        CommonHellper.animateView(view: imgMartine)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func doFilter(_ sender: Any) {
        prep = 10
        self.setColorTextNormalOrSelect(lable: lblShake, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblFilter, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblStir, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMuddle, isSelect: false)
        setImageSeletd(imageView: imgShake, uimage: #imageLiteral(resourceName: "prep_shake1"))
        setImageSeletd(imageView: imgFilter, uimage: #imageLiteral(resourceName: "prep_filter2"))
        setImageSeletd(imageView: imgStir, uimage: #imageLiteral(resourceName: "prep_stir1"))
        setImageSeletd(imageView: imgMuddle, uimage: #imageLiteral(resourceName: "prep_muddle1"))
        CommonHellper.animateView(view: imgFilter)
    }
    @IBAction func doShake(_ sender: Any) {
        prep = 0
        self.setColorTextNormalOrSelect(lable: lblShake, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblFilter, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblStir, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMuddle, isSelect: false)
         setImageSeletd(imageView: imgShake, uimage: #imageLiteral(resourceName: "prep_shake2"))
        setImageSeletd(imageView: imgFilter, uimage: #imageLiteral(resourceName: "prep_filter1"))
        setImageSeletd(imageView: imgStir, uimage: #imageLiteral(resourceName: "prep_stir1"))
        setImageSeletd(imageView: imgMuddle, uimage: #imageLiteral(resourceName: "prep_muddle1"))
        CommonHellper.animateView(view: imgShake)
    }
    @IBAction func doStir(_ sender: Any) {
        prep = 20
        self.setColorTextNormalOrSelect(lable: lblShake, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblFilter, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblStir, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblMuddle, isSelect: false)
        setImageSeletd(imageView: imgShake, uimage: #imageLiteral(resourceName: "prep_shake1"))
        setImageSeletd(imageView: imgFilter, uimage: #imageLiteral(resourceName: "prep_filter1"))
        setImageSeletd(imageView: imgStir, uimage: #imageLiteral(resourceName: "prep_stir2"))
        setImageSeletd(imageView: imgMuddle, uimage: #imageLiteral(resourceName: "prep_muddle1"))
        CommonHellper.animateView(view: imgStir)
    }
    @IBAction func doMuddle(_ sender: Any) {
        prep = 30
        self.setColorTextNormalOrSelect(lable: lblShake, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblFilter, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblStir, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblMuddle, isSelect: true)
        setImageSeletd(imageView: imgShake, uimage: #imageLiteral(resourceName: "prep_shake1"))
        setImageSeletd(imageView: imgFilter, uimage: #imageLiteral(resourceName: "prep_filter1"))
        setImageSeletd(imageView: imgStir, uimage: #imageLiteral(resourceName: "prep_stir1"))
        setImageSeletd(imageView: imgMuddle, uimage: #imageLiteral(resourceName: "prep_muddle2"))
        CommonHellper.animateView(view: imgMuddle)
    }
    
    @IBAction func doNone(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none2"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
        CommonHellper.animateView(view: imgNone)
    }
    @IBAction func doSome(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: true)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: false)
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none1"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some2"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal1"))
        CommonHellper.animateView(view: imgSome)
    }
    @IBAction func doNormal(_ sender: Any) {
        self.setColorTextNormalOrSelect(lable: lblNone, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblSome, isSelect: false)
        self.setColorTextNormalOrSelect(lable: lblNormal, isSelect: true)
        
        setImageSeletd(imageView: imgNone, uimage: #imageLiteral(resourceName: "ice_none1"))
        setImageSeletd(imageView: imgSome, uimage: #imageLiteral(resourceName: "ice_some1"))
        setImageSeletd(imageView: imgNormal, uimage: #imageLiteral(resourceName: "ice_normal2"))
        CommonHellper.animateView(view: imgNormal)
    }
    
    @IBAction func doGiam(_ sender: Any) {
        if numberQuanlity > 1 {
            numberQuanlity = numberQuanlity - 1
            lblQuanlity.text = "\(numberQuanlity)"
            CommonHellper.animateView(view: lblQuanlity)
        }
    }
    @IBAction func doTang(_ sender: Any) {
        numberQuanlity = numberQuanlity + 1
        lblQuanlity.text = "\(numberQuanlity)"
        CommonHellper.animateView(view: lblQuanlity)
    }
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func paraStepOne()->Parameters
    {
        var parameters: [String: AnyObject] = [:]
        parameters["name"] = self.txfDrinkName.text! as AnyObject
        var arrs = [NSDictionary]()
        for obj in arringredients {
            let dict = obj as! NSDictionary
            if let val = dict.object(forKey: "ingredient") as? NSDictionary
            {
                if let idIn = val.object(forKey: "id") as? Int
                {
                    let para = ["ratio": dict.object(forKey: "ratio") as! Int,"unit":0,"ingredient":idIn]
                    arrs.append(para as NSDictionary)
                    //parameters["ingredients"] = para as AnyObject
                }
            }
        }
        parameters["ingredients"] = arrs as AnyObject
        parameters["prep"] = prep as AnyObject
        return parameters
        
    }
    @IBAction func doAddCustom(_ sender: TransitionButton) {
        ManagerWS.shared.addDrinkStep1(para: self.paraStepOne()) { (success) in
            
        }
//        btnAddCustom.startAnimation() // 2: Then start the animation when the user tap the button
//
//        let qualityOfServiceClass = DispatchQoS.QoSClass.background
//        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
//        backgroundQueue.async(execute: {
//
//            sleep(1) // 3: Do your networking task or background work here.
//
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.btnAddCustom.setTitle("", for: .normal)
//                self.btnAddCustom.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
//                // 4: Stop the animation, here you have three options for the `animationStyle` property:
//                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
//                // .shake: when you want to reflect to the user that the task did not complete successfly
//                // .normal
//                self.btnAddCustom.stopAnimation(animationStyle: .shake, completion: {
//                })
//                self.perform(#selector(self.returnCustom), with: nil, afterDelay: 1.5)
//            })
//        })
    }
    
    @objc func returnCustom()
    {
       self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 3
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

extension CustomDetailVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfDrinkName.isEnabled = false
        isEditName = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.widthTxfDrinkName.constant = 140
            self.leaningBtnName.constant = 7
        }, completion: { (success) in
            self.txfDrinkName.resignFirstResponder()
        })
        return true
    }
}
extension CustomDetailVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arringredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDetail.dequeueReusableCell(withIdentifier: "CustomDetailCell") as! CustomDetailCell
        self.configCellCustomDetailCell(cell, dict: arringredients[indexPath.row] as! NSDictionary)
        cell.tapRemove = { [] in
            self.arringredients.removeObject(at: indexPath.row)
            self.heightTable.constant = CGFloat(self.arringredients.count * 44)
            self.tblDetail.reloadData()
        }
        return cell
    }
    
    func configCellCustomDetailCell(_ cell: CustomDetailCell, dict: NSDictionary)
    {
        cell.lblValue.text = "\(dict.object(forKey: "ratio") as! Int)"
        cell.lblUnit.text = dict.object(forKey: "unit") as? String
        if let val = dict.object(forKey: "ingredient") as? NSDictionary
        {
            if let name = val.object(forKey: "name") as? String
            {
                cell.lblName.text = name
            }
        }
        
    }
}

extension CustomDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.arrLys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LyTailCell", for: indexPath) as! LyTailCell
        self.configCell(cell, glassObj: arrLys[indexPath.row])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 80, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.arrLys[indexPath.row]
        if obj.image != nil{
            self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            })
        }
         self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
    }
    
    func configCell(_ cell: LyTailCell, glassObj: GlassObj)
    {
        cell.lblName.text = glassObj.name
        if glassObj.image != nil
        {
            cell.imgCell.sd_setImage(with: URL.init(string: glassObj.image!), completed: { (image, error, type, url) in
                
            })
        }
    }
}

