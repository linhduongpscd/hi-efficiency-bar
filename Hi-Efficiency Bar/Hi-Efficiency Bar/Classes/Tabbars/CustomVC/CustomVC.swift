//
//  CustomVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import MXParallaxHeader
class CustomVC: HelpController {
    var tapSelectedIng: (() ->())?
    @IBOutlet var subNavi: UIView!
    @IBOutlet weak var imgReset: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrTypes = [MainBarObj]()
    var arrDatas = [MainBarObj]()
    var isLoad = false
    var arrSelected = [Int]()
    var arrIngredientSelected = [Ingredient]()
    @IBOutlet weak var lblNoData: UILabel!
    var isAddCustom = false
    var id =  Int()
     var closeBar = CloseBar.init(frame: .zero)
    @IBOutlet weak var btnNext: SSSpinnerButton!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CustomVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        // refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing please wait...", attributes: attributes)
        return refreshControl
    }()
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var constraintBottomNavi: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Custom"
        
        self.registerCell()
        self.fecthingredientType()
        lblNoData.isHidden = true
       
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("iPhone X")
                heightNavi.constant = 84
            default:
                print("unknown")
            }
        }
       // self.collectionView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        ManagerWS.shared.fetchIngredientbyTypeID(id) { (success, arrs, code) in
            CommonHellper.hideBusy()
            self.refreshControl.endRefreshing()
            self.arrDatas = arrs!
            if self.arrDatas.count == 0
            {
                self.lblNoData.isHidden = false
            }
            else{
                self.lblNoData.isHidden = true
            }
            self.collectionView.reloadData()
            
        }
    }
    
    
    
    
    func showPopUpCloseBar()
    {
        self.closeBar.removeFromSuperview()
        closeBar = Bundle.main.loadNibNamed("CloseBar", owner: self, options: nil)?[0] as! CloseBar
        closeBar.registerCell()
        closeBar.frame = UIScreen.main.bounds
        closeBar.tapRefresh = { [] in
            ManagerWS.shared.getSettingApp { (success) in
                if !success!
                {
                    self.showPopUpCloseBar()
                }
                else{
                    self.closeBar.removeFromSuperview()
                    self.fechByTypeID(id: self.id)
                }
            }
        }
        APP_DELEGATE.window?.addSubview(closeBar)
    }
    func fecthingredientType()
    {
        ManagerWS.shared.fetchIngredientType { (success, arrs) in
            self.arrTypes = arrs!
            self.initpalalax()
            if self.arrTypes.count > 0
            {
                let obj = self.arrTypes[0]
                self.id = obj.id!
                
                self.fechByTypeID(id: obj.id!)
            }
        }
    }
    
    func fechByTypeID(id: Int)
    {
         self.id = id
        CommonHellper.showBusy()
        ManagerWS.shared.fetchIngredientbyTypeID(id) { (success, arrs, code) in
             CommonHellper.hideBusy()
            if code == SERVER_CODE.CODE_403
            {
                self.showPopUpCloseBar()
            }
            else{
                CommonHellper.hideBusy()
                self.arrDatas = arrs!
               
                if self.arrDatas.count == 0
                {
                    self.lblNoData.isHidden = false
                }
                else{
                    self.lblNoData.isHidden = true
                }
                self.collectionView.reloadData()
            }
        }
    }
   
    
    @IBAction func doReset(_ sender: Any) {

        CATransaction.begin()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = kSPEED_REODER
        rotationAnimation.repeatCount = 1
        
        CATransaction.setCompletionBlock {
            self.arrSelected.removeAll()
            self.collectionView.reloadData()
//            CATransaction.begin()
//            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
//            rotationAnimation.duration = 0.4
//            rotationAnimation.repeatCount = 1
//
//            CATransaction.setCompletionBlock {
//                self.arrSelected.removeAll()
//                self.collectionView.reloadData()
//            }
//            self.imgReset.layer.add(rotationAnimation, forKey: nil)
//            CATransaction.commit()
        }
        self.imgReset.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
    }
    func initpalalax()
    {
        let headerView = Bundle.main.loadNibNamed("HeaderCustom", owner: self, options: nil)?[0] as! HeaderCustom
        headerView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 195 + (UIScreen.main.bounds.size.width - 320))
        headerView.registerCell()
        headerView.arrSlices = arrTypes
        headerView.collectionView.reloadData()
        headerView.tapClick = { [] in
            let obj = self.arrTypes[headerView.currentDot]
            self.fechByTypeID(id: obj.id!)
        }
        if self.arrTypes.count > 0
        {
            let obj = self.arrTypes[headerView.currentDot]
            headerView.lblName.text = obj.name
        }
        collectionView.parallaxHeader.delegate = self
        collectionView.parallaxHeader.view = headerView
        collectionView.parallaxHeader.height = 195 + (UIScreen.main.bounds.size.width - 320)
        collectionView.parallaxHeader.mode = .fill
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrSelected.removeAll()
        self.arrIngredientSelected.removeAll()
        self.collectionView.reloadData()
        self.btnNext.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
        self.btnNext.setTitle("NEXT", for: .normal)
        self.btnNext.setImage(UIImage.init(), for: .normal)
         self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: UITableViewDelegate
    
   
    
    func registerCell()
    {
         self.collectionView.register(UINib(nibName: "IngreItemCollectCus", bundle: nil), forCellWithReuseIdentifier: "IngreItemCollect")
        self.collectionView.register(UINib(nibName: "TopSectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopSectionViewCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.ingredient_by
    }
    @IBAction func btnNext(_ sender: SSSpinnerButton) {
        
        if isAddCustom
        {
            self.tapSelectedIng?()
            self.dismiss(animated: true, completion: nil)
        }
        else{
            if self.arrIngredientSelected.count == 0
            {
                self.showAlertMessage(message: "Please select ingredient")
                return
            }
            sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
            sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
            self.perform(#selector(self.initStopAnimal), with: nil, afterDelay: 0.55)
        }
       
    }
    
    @objc func initStopAnimal()
    {
        self.btnNext.stopAnimate(complete: {
            self.btnNext.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
            self.btnNext.setTitle("", for: .normal)
            self.btnNext.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
            self.perform(#selector(self.initComplete), with: nil, afterDelay: 0.1)
        })
        
    }
    @objc func initComplete()
    {
      
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CustomDetailVC") as! CustomDetailVC
        vc.isRedirectCus = true
        vc.arrCusIngredients = self.arrIngredientSelected
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CustomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       let mainObj = arrDatas[section]

        return mainObj.arrIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainObj = arrDatas[indexPath.section]
        let item = mainObj.arrIngredients[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngreItemCollect", for: indexPath) as! IngreItemCollect
       
        cell.lbltext.text = item.name
        if arrSelected.contains(item.id!)
        {
            cell.lbltext.font = UIFont.init(name: FONT_APP.AlrightSans_Bold, size: cell.lbltext.font.pointSize)
            cell.subContent.borderWidth = 2.0
            cell.subContent.borderColor =  UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha:1.0)
            cell.imgCheck.isHidden = false
             cell.spaceCheck.constant = 35
        }
        else{
            cell.lbltext.font = UIFont.init(name: FONT_APP.AlrightSans_Regular, size: cell.lbltext.font.pointSize)
            cell.subContent.borderWidth = 0.0
            cell.subContent.borderColor =  UIColor.clear
            cell.imgCheck.isHidden = true
            cell.spaceCheck.constant = 10
            
        }
        cell.lbltext.textColor = UIColor.black
        cell.subContent.backgroundColor = item.bgColor!
       return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      
        return CGSize(width: (collectionView.frame.size.width - 4)/2, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainObj = arrDatas[indexPath.section]
        let item = mainObj.arrIngredients[indexPath.row]
        let arrSelectSearch = self.arrSelected
        if arrSelected.contains(item.id!)
        {
            for var i in 0..<arrSelectSearch.count
            {
                if arrSelectSearch[i] == item.id!
                {
                    self.arrSelected.remove(at: i)
                    self.arrIngredientSelected.remove(at: i)
                }
            }
        }
        else{
            self.arrIngredientSelected.append(item)
            arrSelected.append(item.id!)
        }
        collectionView.reloadData()
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader
        {
            let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopSectionViewCell", for: indexPath) as! TopSectionViewCell
            let obj = self.arrDatas[indexPath.section]
            commentView.lblTitle.text = obj.name
            
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
extension CustomVC: MXParallaxHeaderDelegate
{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
       // print(parallaxHeader.progress)
        
        if parallaxHeader.progress > 1.0
        {
            parallaxHeader.view?.transform = CGAffineTransform.identity
           // self.lblNavi.transform = CGAffineTransform.identity
            constraintBottomNavi.constant = 15.0
        }
        else{
            parallaxHeader.view?.transform = CGAffineTransform.init(scaleX: parallaxHeader.progress, y: parallaxHeader.progress)
            //rself.lblNavi.transform = CGAffineTransform.init(scaleX: parallaxHeader.progress, y: parallaxHeader.progress)
            self.constraintBottomNavi.constant = 100
        }
    }
    
}
