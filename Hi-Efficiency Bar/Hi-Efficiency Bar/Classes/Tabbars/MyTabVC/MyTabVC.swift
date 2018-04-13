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
class MyTabVC: BaseViewController {

    @IBOutlet weak var tblMyTab: UITableView!
    @IBOutlet weak var btnMakeMeDrink: TransitionButton!
    var arrMyTabs = [MyTabObj]()
    var doublePrice = 0.0
    var customerContext: STPCustomerContext!
    var paymentContext: STPPaymentContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tab"
        btnMakeMeDrink.spinnerColor = .white
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
        //initParalax()
        self.configHideNaviTable(tblMyTab)
        customerContext = STPCustomerContext.init()
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        paymentContext.paymentAmount = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
            self.fetchALlMyTab()
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
                price = price + Double((obj.quantity! * obj.price!))
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
    
    @IBAction func doMakeMeADrink(_ sender: Any) {
        btnMakeMeDrink.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnMakeMeDrink.setTitle("", for: .normal)
                self.btnMakeMeDrink.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnMakeMeDrink.stopAnimation(animationStyle: .shake, completion: {
                    
                    
                })
                self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 1.5)
            })
        })
    }
    
    @objc func actionTabbar()
    {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func presentPaymentMethodsViewController() {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            // Present error immediately because publishable key needs to be set
            let message = "Please assign a value to `publishableKey` before continuing. See `AppDelegate.swift`."
            print(message)
            return
        }
        
        
        // Present the Stripe payment methods view controller to enter payment details
        paymentContext.presentPaymentMethodsViewController()
    }
}

extension MyTabVC: STPPaymentContextDelegate
{
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print(error)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        // Create charge using payment result
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            // Animate active ride
            break
        case .error:
            // Present error to user
            break
            
        case .userCancellation:
            break
        }
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
            cell.lblPrice.text = "$\(doublePrice)"
            cell.lblTotalPay.text = "$\(doublePrice)"
            cell.tapStripeVisa = { [] in
                //self.presentPaymentMethodsViewController()
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
            cell.lblPrice.text = "$\(obj.quantity! * obj.price!)"
        }
    }
}
