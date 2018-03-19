//
//  BaseViewController.swift
//  projectX
//
//  Created by Colin Ngo on 1/22/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.isNavigationBarHidden = false
        setupNavi()
        // Do any additional setup after loading the view.
    }
    func setupNavi()
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
       // self.navigationController?.navigationBar.barTintColor = UIColor.init(patternImage: #imageLiteral(resourceName: "color_navi"))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Raleway-Medium", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func initLeftNaviCus(str: String)
    {
        let btnCus = UIButton.init()
        btnCus.frame = CGRect(x:0,y:0, width: 200, height: 44)
        btnCus.backgroundColor = UIColor.clear
        btnCus.setImage(#imageLiteral(resourceName: "btn_back"), for: .normal)
        btnCus.setTitle("   \(str.uppercased())", for: .normal)
        btnCus.contentHorizontalAlignment = .left
        btnCus.titleLabel?.font = UIFont(name: "Raleway-Medium", size: 16)!
        btnCus.setTitleColor(UIColor.white, for: .normal)
        btnCus.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        let btn = UIBarButtonItem.init(customView: btnCus)
        self.navigationItem.leftBarButtonItem = btn
    }
    
    @objc func clickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Close",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   
    
  

}


