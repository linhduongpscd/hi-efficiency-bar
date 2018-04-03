//
//  CustomVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CustomVC: UIViewController {
    
    @IBOutlet weak var tblCustom: UITableView!
      var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet var subNavi: UIView!
    @IBOutlet weak var imgReset: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Custom"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.registerCell()
         hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tblCustom)
        self.customNavi()
        // Do any additional setup after loading the view.
    }
    
    func customNavi()
    {
        let btn = UIBarButtonItem.init(customView: subNavi)
        self.navigationItem.rightBarButtonItem = btn
    }
    @IBAction func doReset(_ sender: Any) {

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
            self.imgReset.layer.add(rotationAnimation, forKey: nil)
            CATransaction.commit()
        }
        self.imgReset.layer.add(rotationAnimation, forKey: nil)
        CATransaction.commit()
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
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    func registerCell()
    {
        tblCustom.register( UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tblCustom.register( UINib(nibName: "HeaderCustomCell", bundle: nil), forCellReuseIdentifier: "HeaderCustomCell")
        tblCustom.register( UINib(nibName: "FooterCustomCell", bundle: nil), forCellReuseIdentifier: "FooterCustomCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CustomVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        cell.lblTitleCell.text = "Rum brand \(indexPath.row + 1) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 260
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = Bundle.main.loadNibNamed("HeaderCustom", owner: self, options: nil)?[0] as! HeaderCustom
            headerView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 260)
            headerView.registerCell()
            return headerView
        }
       
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "HeaderCustomCell") as! HeaderCustomCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if  section == 0 {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if  section == 0 {
            let view = UIView.init(frame: .zero)
            return view
        }
        let cell = self.tblCustom.dequeueReusableCell(withIdentifier: "FooterCustomCell") as! FooterCustomCell
        cell.tapClickNext = { [weak self] in
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CustomDetailVC") as! CustomDetailVC
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
   
}
