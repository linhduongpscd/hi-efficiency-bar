//
//  ScannerVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ScannerVC: UIViewController {

    @IBOutlet weak var lblNumberOnTray: UILabel!
    @IBOutlet weak var imgQrCode: UIImageView!
    var userOrderObj = OrderUserObj.init(dict: NSDictionary.init())
    @IBOutlet weak var spaceRight: NSLayoutConstraint!
    @IBOutlet weak var spaceTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if userOrderObj.tray_number != nil
        {
            self.lblNumberOnTray.text = "Pick up on tray: \(userOrderObj.tray_number!)"
        }
        
        if userOrderObj.qr_code != nil
        {
            self.imgQrCode.sd_setImage(with: URL.init(string: userOrderObj.qr_code!), completed: { (image, error, type, url) in
                
            })
        }
        if UIScreen.main.bounds.size.height == 812.0 {
            self.spaceTop.constant = 112.0
            self.spaceRight.constant = 115.0
        } else if UIScreen.main.bounds.size.height == 736.0 {
            self.spaceTop.constant = 120.0
            self.spaceRight.constant = 130.0
        }
        else if UIScreen.main.bounds.size.height == 667.0 {
            self.spaceTop.constant = 90.0
            self.spaceRight.constant = 118.0
        }
        else if UIScreen.main.bounds.size.height == 568.0 {
            self.spaceTop.constant = 50.0
            self.spaceRight.constant = 95.0
        }
        // Do any additional setup after loading the view.
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
    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
