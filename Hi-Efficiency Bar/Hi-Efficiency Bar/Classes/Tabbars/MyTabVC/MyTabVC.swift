//
//  MyTabVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Stripe
import Photos
class MyTabVC: BaseViewController {

    @IBOutlet weak var tblMyTab: UITableView!
    @IBOutlet weak var btnMakeMeDrink: SSSpinnerButton!
    var arrMyTabs = [MyTabObj]()
    var doublePrice = 0.0
    var tokenStriper = ""
    var isReload = false
    var stpToke: STPToken?
    @IBOutlet weak var cameraView: UIView!
     let cameraManager = CameraManager()
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tab"
        btnMakeMeDrink.spinnerColor = .white
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
        self.configHideNaviTable(tblMyTab)
       self.confiCamera()
        cameraView.isHidden = true
    }
    
    func confiCamera()
    {
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        cameraManager.flashMode = .off
        cameraManager.cameraDevice = CameraDevice.front
        
        self.askForCameraPermissions()
        
    }
    @IBAction func askForCameraPermissions() {
        
        self.cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if !isReload
        {
             self.fetchALlMyTab()
        }
        else{
            isReload = false
        }
        cameraManager.resumeCaptureSession()
        self.btnMakeMeDrink.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    fileprivate func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func fetchALlMyTab()
    {
        CommonHellper.showBusy()
        ManagerWS.shared.getListMyTab { (success, arrs) in
            self.arrMyTabs.removeAll()
            CommonHellper.hideBusy()
            self.arrMyTabs = arrs!
            self.doublePrice = self.getPriceTotal()
            self.tblMyTab.reloadData()
        }
        
    }
    
    func getPriceTotal()-> Double
    {
        var price = 0.0
        for obj in self.arrMyTabs
        {
            if obj.price != nil
            {
                price = price + Double((Double(obj.quantity!) * Double(obj.price!)))
            }
        }
        return price
    }
    
    func getQuanlity()-> Int
    {
        var price = 0
        for obj in self.arrMyTabs
        {
            if obj.quantity != nil
            {
                price = price + obj.quantity!
            }
        }
        return price
    }
    
    func initParalax()
    {
        let profileView = UIView.init()
        profileView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 30)
        tblMyTab.parallaxHeader.delegate = self
        tblMyTab.parallaxHeader.view = profileView
        tblMyTab.parallaxHeader.height = 30
        tblMyTab.parallaxHeader.mode = .fill
        
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveCardNotImage(_ isImage: Bool, _ image: UIImage)
    {
        if !isImage
        {
            ManagerWS.shared.addMyTabCard(token: self.tokenStriper, complete: { (success, error) in
                
                if success!
                {
                    self.btnMakeMeDrink.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnMakeMeDrink.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.btnMakeMeDrink.setTitle("", for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                         self.btnMakeMeDrink.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                        self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.5)
                    })
                   
                  
                    
                }
                else{
                   self.btnMakeMeDrink.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnMakeMeDrink.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                        self.showAlertMessage(message:(error?.msg!)!)
                    })
                    
                }
            })
        }
        else{
            ManagerWS.shared.addMyCardImage(token: self.tokenStriper, image: image, complete: { (success, error) in
                
                if success!
                {
                    self.btnMakeMeDrink.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnMakeMeDrink.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.btnMakeMeDrink.setTitle("", for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                        self.btnMakeMeDrink.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                        self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 0.5)
                    })
                }
                else{
                    self.btnMakeMeDrink.stopAnimate(complete: {
                        self.removeLoadingView()
                        self.btnMakeMeDrink.setBackgroundImage(#imageLiteral(resourceName: "btn"), for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
                        self.btnMakeMeDrink.setImage(UIImage.init(), for: .normal)
                        self.showAlertMessage(message:(error?.msg!)!)
                    })
                }
            })
        }
    }
    @IBAction func doMakeMeADrink(_ sender: SSSpinnerButton) {
        
        if self.arrMyTabs.count == 0
        {
            self.showAlertMessage(message: "You have no drinks in your tab")
            return
        }
        if self.getQuanlity() > 5
        {
            self.showAlertMessage(message: "Your order has more than 5 quantities")
            return
        }
        if tokenStriper.isEmpty
        {
            self.showAlertMessage(message: "Please add card")
            return
        }
        self.addLoadingView()
        sender.setBackgroundImage(#imageLiteral(resourceName: "color_tim"), for: .normal)
        sender.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .white, complete: nil)
        
        self.cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                self.cameraManager.capturePictureWithCompletion({ (image, error) -> Void in

                    if error != nil {
                        //self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                        self.saveCardNotImage(false, UIImage.init())
                    }
                    else {
                        self.saveCardNotImage(true,image!)

                    }
                })
            }
            else{
                self.saveCardNotImage(false, UIImage.init())
            }
        })
        
    }
    
    @objc func actionTabbar()
    {
        stpToke = nil
        tokenStriper = ""
        self.tblMyTab.reloadData()
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
    }
  
}



extension MyTabVC: MXParallaxHeaderDelegate
{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(parallaxHeader.progress)
        if parallaxHeader.progress > 0.0
        {
            self.navigationItem.title = "My Tab"
        }
        else{
            self.navigationItem.title = ""
        }
    }
}
extension MyTabVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyTabs.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 35
        }
        if indexPath.row == arrMyTabs.count + 1
        {
            return 316
        }
        return 70
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "headercell")
            return cell!
        }
        else if indexPath.row == arrMyTabs.count + 1
        {
            let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "visacell") as! visacell
            cell.lblFee.text = "$0"
            cell.lblPrice.text = String(format: "$%.2f", Double(doublePrice))
            cell.lblTotalPay.text = String(format: "$%.2f", Double(doublePrice + CommonHellper.getTaxDrink(doublePrice)))
            cell.lblFee.text =  String(format: "$%.2f", CommonHellper.getTaxDrink(doublePrice))
            cell.tapStripeVisa = { [] in
                self.isReload = true
                let addCardViewController = STPAddCardViewController()
                addCardViewController.delegate = self
                addCardViewController.managedAccountCurrency = "usd"
                let navigationController = UINavigationController(rootViewController: addCardViewController)
                self.present(navigationController, animated: true)
            }
            if stpToke != nil
            {
                cell.lblNumberHide.text = "****"
                cell.lblLastCard.text = stpToke?.card?.last4
                if stpToke?.card?.brand == .visa
                {
                    cell.imgCard.image = #imageLiteral(resourceName: "visa")
                }
                else if stpToke?.card?.brand == .masterCard
                {
                    cell.imgCard.image = #imageLiteral(resourceName: "mastercard")
                }
                else{
                    cell.imgCard.image = #imageLiteral(resourceName: "card")
                }
            }
            else{
                cell.lblNumberHide.text = ""
                cell.lblLastCard.text = ""
                cell.imgCard.image = UIImage.init()
            }
            return cell
        }
        let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "MyTabCell") as! MyTabCell
        if indexPath.row == arrMyTabs.count
        {
            cell.subLine.isHidden = true
        }
        else
        {
            cell.subLine.isHidden = false
        }
        self.configCell(cell, obj: arrMyTabs[indexPath.row - 1])
        cell.myTabObj = arrMyTabs[indexPath.row - 1]
        cell.tapDeleteMyTab = { [] in
            let alert = UIAlertController(title: APP_NAME,
                                          message: ALERT_DELETE,
                                          preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "Delete", style: .destructive, handler: { (action) in
                let obj = self.arrMyTabs[indexPath.row - 1]
                ManagerWS.shared.deleteMyTab(tabID: obj.id!, complete: { (success) in
                    self.arrMyTabs.remove(at: indexPath.row - 1)
                    self.doublePrice = self.getPriceTotal()
                    self.tblMyTab.reloadData()
                })
                
                
            })
            alert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        cell.changePrice = { [] in
            self.doublePrice = self.getPriceTotal()
            self.tblMyTab.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vc = UIView.init(frame: .zero)
        return vc
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0
        {
            return false
        }
        if indexPath.row == arrMyTabs.count + 1
        {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let alert = UIAlertController(title: APP_NAME,
                                          message: ALERT_DELETE,
                                          preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "Delete", style: .destructive, handler: { (action) in
                let obj = self.arrMyTabs[indexPath.row - 1]
                CommonHellper.showBusy()
                ManagerWS.shared.deleteMyTab(tabID: obj.id!, complete: { (success) in
                    CommonHellper.hideBusy()
                    self.arrMyTabs.remove(at: indexPath.row - 1)
                   self.doublePrice = self.getPriceTotal()
                    self.tblMyTab.reloadData()
                })
                
                
            })
             alert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configCell(_ cell: MyTabCell, obj: MyTabObj)
    {
        cell.lblName.text = obj.name
        cell.lblQuanlity.text = "\(obj.quantity!)"
        if obj.image != nil
        {
            cell.imgCell.sd_setImage(with: URL.init(string: obj.image!), completed: { (image, error, type, url) in
                
            })
        }
        if obj.price == nil
        {
            cell.lblPrice.text = "$0"
        }
        else{
            cell.lblPrice.text =  String(format: "$%.2f", Double((Double(obj.quantity!) * Double(obj.price!))))
        }
    }
}

extension MyTabVC: STPAddCardViewControllerDelegate
{
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        tokenStriper = token.tokenId
        stpToke = token
        self.tblMyTab.reloadData()
        dismiss(animated: true)
    }
}
