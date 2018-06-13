//
//  CustomDetailVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class CustomDetailVC: HelpController {

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
    var arringredients = [IngredientCusObj]()
    var prep = 0
    var glassObj: GlassObj?
    var glassID: Int?
    var valueIce = 0
    var isRedirectCus = false
    var arrCusIngredients = [Ingredient]()
    var arrUnitView = ["oz","%","part","mL", "dash" , "splash" ,"teaspoon","tablespoon","pony","jigger","shot","snit","split"]
    @IBOutlet weak var btnFullEditName: UIButton!
     var closeBar = CloseBar.init(frame: .zero)
    var indexSelected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddCustom.spinnerColor = .white
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollPage)
        let btnRight = UIBarButtonItem.init(customView: subNaviRight)
        self.navigationItem.rightBarButtonItem = btnRight
        txfDrinkName.isEnabled = false
        if !isRedirectCus
        {
             glassObj = GlassObj.init(dict: drinkObj.glass!)
        }
       self.fectAllGlass()
    }
    
    func showPopUpCloseBar(_ isAdd: Bool)
    {
        self.closeBar.removeFromSuperview()
        closeBar = Bundle.main.loadNibNamed("CloseBar", owner: self, options: nil)?[0] as! CloseBar
        closeBar.registerCell()
        closeBar.frame = UIScreen.main.bounds
        closeBar.tapRefresh = { [] in
            if isAdd
            {
                 self.closeBar.removeFromSuperview()
            }
            else{
                self.fectAllGlass()
            }
        }
        APP_DELEGATE.window?.addSubview(closeBar)
    }
    
    func initData()
    {
        if !isRedirectCus
        {
            arringredients.removeAll()
            for recod in drinkObj.ingredients!
            {
                let dict = recod as! NSDictionary
                arringredients.append(IngredientCusObj.init(dict: dict))
            }
            self.changeRationUnitPart()
            heightTable.constant = CGFloat(arringredients.count * 44)
             txfDrinkName.text = drinkObj.name
        }
        else{
             arringredients.removeAll()
            for recod in arrCusIngredients
            {
                let obj = IngredientCusObj.init(dict: NSDictionary.init())
                obj.id = recod.id
                obj.unit_view = "ml"
                obj.ratio = 0
                obj.value = 0
                obj.unit = 0
                obj.name = recod.name
                arringredients.append(obj)
            }
            self.changeRationUnitPart()
            heightTable.constant = CGFloat(arringredients.count * 44)
            txfDrinkName.placeholder = "Name drink"
            txfDrinkName.text = ""
        }
        if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
        {
            self.lblMaxSize.textColor = UIColor.red
        }
        else{
            self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
        }
    }
    
    func changeRationUnitPart()
    {
        for obj in self.arringredients
        {
            obj.value = CommonHellper.convertMLDrink(unit: (obj.unit_view?.lowercased())!, number: obj.ratio!)
        }
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
        ManagerWS.shared.getListAllGlass { (success, arrs, code) in
            if success!
            {
                self.closeBar.removeFromSuperview()
                self.arrLys = arrs!
                self.collectionLy.reloadData()
                var i = 0
                if self.arrLys.count > 0
                {
                    if !self.isRedirectCus
                    {
                        for obj in self.arrLys
                        {
                            if obj.id == self.glassObj?.id
                            {
                                self.indexSelected = i
                                self.glassObj = obj
                                self.glassID = obj.id
                                if obj.image != nil{
                                    self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                                        if error == nil
                                        {
                                            self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                                            self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                                        }
                                        
                                    })
                                }
                                if self.glassObj?.unit_view == "oz"
                                {
                                    self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!) (\(obj.change_to_ml!) ml)"
                                }
                                else{
                                    self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
                                }
                                break
                            }
                            i = i + 1
                        }
                    }
                    else{
                        let obj = self.arrLys[0]
                        self.glassObj = obj
                        self.glassID = obj.id
                        if obj.image != nil{
                            self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                                if error == nil
                                {
                                    self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                                    self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                                }
                             
                            })
                        }
                        if self.glassObj?.unit_view == "oz"
                        {
                            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!) (\(obj.change_to_ml!) ml)"
                        }
                        else{
                            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
                        }
                    }
                    
                    
                }
                else{
                    self.lblMaxSize.text = ""
                }
                self.initData()
                self.setDefault()
            }
            else{
                if code == SERVER_CODE.CODE_403
                {
                    self.showPopUpCloseBar(false)
                }
            }
        }
    }
    
    func fectAllGlassReset()
    {
        ManagerWS.shared.getListAllGlass { (success, arrs, code) in
            if success!
            {
                self.closeBar.removeFromSuperview()
                self.arrLys = arrs!
                self.collectionLy.reloadData()
                if self.arrLys.count > 0
                {
                    if !self.isRedirectCus
                    {
                        for obj in self.arrLys
                        {
                            if obj.id == self.glassObj?.id
                            {
                                self.glassObj = obj
                                self.glassID = obj.id
                                if obj.image != nil{
                                    self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                                        self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                                        self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                                    })
                                }
                                if self.glassObj?.unit_view == "oz"
                                {
                                    self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!) (\(obj.change_to_ml!) ml)"
                                }
                                else{
                                    self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
                                }
                                
                                
                                break
                            }
                        }
                    }
                    else{
                        let obj = self.arrLys[0]
                        self.glassObj = obj
                        self.glassID = obj.id
                        if obj.image != nil{
                            self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                                self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                                self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                            })
                        }
                        if self.glassObj?.unit_view == "oz"
                        {
                            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!) (\(obj.change_to_ml!) ml)"
                        }
                        else{
                            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
                        }
                    }
                    
                    
                }
                else{
                    self.lblMaxSize.text = ""
                }
                self.initDataReset()
                self.setDefault()
            }
            else{
                if code == SERVER_CODE.CODE_403
                {
                    self.showPopUpCloseBar(false)
                }
            }
        }
    }
    func initDataReset()
    {
        
        if !isRedirectCus
        {
            arringredients.removeAll()
            for recod in drinkObj.ingredients!
            {
                let dict = recod as! NSDictionary
                arringredients.append(IngredientCusObj.init(dict: dict))
            }
            self.changeRationUnitPart()
            heightTable.constant = CGFloat(arringredients.count * 44)
            txfDrinkName.text = drinkObj.name
        }
        else{
            arringredients.removeAll()
            self.changeRationUnitPart()
            heightTable.constant = CGFloat(arringredients.count * 44)
            txfDrinkName.placeholder = "Name drink"
            txfDrinkName.text = ""
        }
        print(self.getTotolRatioUnit())
        if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
        {
            self.lblMaxSize.textColor = UIColor.red
        }
        else{
            self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
        }
        
    }
    
    
    @IBAction func doEditName(_ sender: Any) {
        if !isEditName {
            txfDrinkName.isEnabled = true
            isEditName = true
            btnFullEditName.isHidden = true
            
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
                self.fectAllGlassReset()
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
        numberQuanlity = 1
        lblQuanlity.text = "\(numberQuanlity)"
       valueIce = 0
         prep = 0
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
    
    @IBAction func doAdd(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tab3 = storyboard.instantiateViewController(withIdentifier: "CustomVC") as! CustomVC
        tab3.tapSelectedIng = { [] in
            for recod in tab3.arrIngredientSelected
            {
                let obj = IngredientCusObj.init(dict: NSDictionary.init())
                obj.id = recod.id
                obj.unit_view = "ml"
                obj.ratio = 0
                obj.value = 0
                obj.unit = 0
                obj.name = recod.name
                self.arringredients.append(obj)
            }
            self.changeRationUnitPart()
            self.heightTable.constant = CGFloat(self.arringredients.count * 44)
            if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
            {
                self.lblMaxSize.textColor = UIColor.red
            }
            else{
                self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            }
        }
        tab3.isAddCustom = true
        let nav = BaseNaviController.init(rootViewController: tab3)
        self.present(nav, animated: true, completion: nil)
    }
    
    func convertParamToWS()->NSDictionary
    {
      
        let value = ["name": self.txfDrinkName.text!,
                     "glass": "\(self.glassID!)",
                    "prep":"\(prep)",
                "ingredients":self.convertArrayToStringIngredient()
            ] as [String : Any] as [String : Any]
        return value as NSDictionary
    }
    
    func convertArrayToStringIngredient()-> String
    {
        var strIngredient = ""
        for obj in arringredients {
            if obj.id != nil
            {
               // strIngredient = "\(strIngredient){\"unit\":\(CommonHellper.valueUnit(unit: obj.unit_view!.lowercased())),\"ratio\":\(obj.value!),\"ingredient\":\(obj.id!)},"
                 strIngredient = "\(strIngredient){\"unit\":\(CommonHellper.valueUnit(unit: obj.unit_view!.lowercased())),\"ratio\":\(obj.ratio!),\"ingredient\":\(obj.id!)},"
            }
            
        }
        if !strIngredient.isEmpty
        {
            strIngredient = strIngredient.substring(from: 0, to: strIngredient.count - 1)
        }
        strIngredient  =  "[\(strIngredient)]"
        return strIngredient
    }
    func addTomyTabParam(drinkID: Int)->Parameters
    {
        let para = ["ice": Int(valueIce), "quantity": lblQuanlity.text!, "drink": drinkID] as [String : Any]
        return para
    }
    @IBAction func doAddCustom(_ sender: TransitionButton) {
        if CommonHellper.trimSpaceString(txtString: txfDrinkName.text!).isEmpty
        {
            self.showAlertMessage(message: "Name drink is required")
            return
        }
        if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
        {
            self.showAlertMessage(message: "Your total custom mL is greater than the max size of drink")
            
            return
        }
        print(self.convertParamToWS())
        self.view.endEditing(true)
        self.addLoadingView()
        btnAddCustom.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            ManagerWS.shared.addDrinkStep1(para: self.convertParamToWS() as! Parameters) { (success, error, drinkID, code) in
                print(success!)
                if success!
                {
                    ManagerWS.shared.addMyTab(para: self.addTomyTabParam(drinkID: drinkID!), complete: { (ok, error, code) in
                        if ok!
                        {
                            self.removeLoadingView()
                            self.btnAddCustom.setTitle("", for: .normal)
                            self.btnAddCustom.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                            self.btnAddCustom.stopAnimation(animationStyle: .shake, completion: {
                                
                                
                            })
                            self.perform(#selector(self.returnCustom), with: nil, afterDelay: 0.5)
                        }
                        else{
                            self.btnAddCustom.stopAnimation(animationStyle: .shake, completion: {
                                self.btnAddCustom.setTitle("ADD TO MY TAB", for: .normal)
                                self.removeLoadingView()
                                if code == SERVER_CODE.CODE_403
                                {
                                    self.showPopUpCloseBar(true)
                                }
                                else{
                                    self.showAlertMessage(message: error!)
                                }
                                
                            })
                        }
                    })
                    
                }
                else{
                    self.btnAddCustom.stopAnimation(animationStyle: .shake, completion: {
                        self.btnAddCustom.setTitle("ADD TO MY TAB", for: .normal)
                        self.removeLoadingView()
                        if code == SERVER_CODE.CODE_403
                        {
                            self.showPopUpCloseBar(true)
                        }
                        else{
                            self.showAlertMessage(message: (error?.msg)!)
                        }
                        
                    })
                }
            }
        })
    }
    
    @objc func returnCustom()
    {
       self.navigationController?.popToRootViewController(animated: true)
       APP_DELEGATE.isRedirectMyTab = true
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
         btnFullEditName.isHidden = false
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
        self.configCellCustomDetailCell(cell, obj: arringredients[indexPath.row])
        cell.ingredientCusObj = arringredients[indexPath.row]
        cell.tapChangeML = { [] in
            print(self.getTotolRatioUnit())
            print(self.glassObj?.change_to_ml as Any)
            for obj in self.arringredients
            {
                obj.value = CommonHellper.convertMLDrink(unit: (obj.unit_view?.lowercased())!, number: obj.ratio!)
            }
            if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
            {
                self.lblMaxSize.textColor = UIColor.red
            }
            else{
                self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
            }
        }
        cell.changeUnitView = { [] in
            let alert = UIAlertController(title: nil,
                                          message: nil,
                                          preferredStyle: UIAlertControllerStyle.actionSheet)
            for str in self.arrUnitView {
                let delete = UIAlertAction.init(title: str, style: .default, handler: { (action) in
                   cell.ingredientCusObj.unit_view = str
                    cell.lblUnit.text = str
                    self.changeRationUnitPart()
                    if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
                    {
                        self.lblMaxSize.textColor = UIColor.red
                    }
                    else{
                        self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                    }
                })
                alert.addAction(delete)
            }
          
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        cell.tapRemove = { [] in
            let alert = UIAlertController(title: APP_NAME,
                                          message: "Are you sure you want to delete?",
                                          preferredStyle: UIAlertControllerStyle.actionSheet)
            let delete = UIAlertAction.init(title: "Delete", style: .destructive, handler: { (action) in
                self.arringredients.remove(at: indexPath.row)
                self.heightTable.constant = CGFloat(self.arringredients.count * 44)
                self.changeRationUnitPart()
                if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
                {
                    self.lblMaxSize.textColor = UIColor.red
                }
                else{
                    self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                }
                self.tblDetail.reloadData()
            })
             alert.addAction(delete)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        return cell
    }
    
    func configCellCustomDetailCell(_ cell: CustomDetailCell, obj: IngredientCusObj)
    {
        if obj.unit != nil{
             cell.txfValue.text = "\(obj.ratio!)"
        }
        else{
             cell.txfValue.text = "0"
        }
       
        cell.lblUnit.text = obj.unit_view
        cell.lblName.text = obj.name
        
    }
    
    func getTotolRatioUnit()-> Double
    {
        var value = 0.0
        for var i in 0..<arringredients.count
        {
             let obj = arringredients[i]
            value = value + obj.value!
           
        }
        return value
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
        self.configCell(cell, glassObj: arrLys[indexPath.row], index: indexPath)
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
        self.indexSelected = indexPath.row
         self.glassObj = obj
        self.collectionLy.reloadData()
        if obj.image != nil{
            let arrs = obj.image?.components(separatedBy: "/")
            let lastName = arrs?.last
            let arrLast = lastName?.components(separatedBy: ".")
            if Int(arrLast!.count) > 0
            {
                if arrLast![1].lowercased() == "svg"
                {
                }
                else{
                    self.imgDrink.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                        if error == nil
                        {
                            self.imgDrink.image = self.imgDrink.image!.withRenderingMode(.alwaysTemplate)
                            self.imgDrink.tintColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                        }
                    })
                }
            }
          
        }
        self.glassID = obj.id
        if self.glassObj?.unit_view == "oz"
        {
            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!) (\(obj.change_to_ml!) ml)"
        }
        else{
            self.lblMaxSize.text = "Max: \(obj.size!) \(obj.unit_view!)"
        }
        self.changeRationUnitPart()
        if self.getTotolRatioUnit() > (self.glassObj?.change_to_ml!)!
        {
            self.lblMaxSize.textColor = UIColor.red
        }
        else{
            self.lblMaxSize.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
        }
    }
    
    func configCell(_ cell: LyTailCell, glassObj: GlassObj, index: IndexPath)
    {
        cell.lblName.text = glassObj.name
        if indexSelected == index.row
        {
            cell.lblName.textColor = UIColor.init(red: 6/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
        }
        else{
            cell.lblName.textColor = UIColor.black
        }
        if glassObj.image != nil
        {
            let arrs = glassObj.image?.components(separatedBy: "/")
            let lastName = arrs?.last
            let arrLast = lastName?.components(separatedBy: ".")
            if Int(arrLast!.count) > 0
            {
                cell.viewSVG.isHidden = true
                cell.imgCell.isHidden = true
                if arrLast![1].lowercased() == "svg"
                {
                    
//                    let svgURL = URL(string: glassObj.image!)!
//                    let hammock = UIView(SVGURL: svgURL) { (svgLayer) in
//                        svgLayer.fillColor = UIColor.lightGray.cgColor
//
//                         svgLayer.resizeToFit(cell.viewSVG.bounds)
//                        cell.viewSVG.layer.addSublayer(svgLayer)
//                    }
                    
                }
                else{
                    cell.viewSVG.isHidden = true
                     cell.imgCell.isHidden = false
                    cell.imgCell.sd_setImage(with: URL.init(string: glassObj.image!), completed: { (image, error, type, url) in
                        if error == nil
                        {
                        }
                        
                    })
                }
            }
        }
    }
}

