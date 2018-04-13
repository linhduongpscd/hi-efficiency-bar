//
//  FlashVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 03/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class FlashVC: UIViewController {

    @IBOutlet weak var imgFlash: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let jeremyGif = UIImage.gifImageWithName("Speed3")
            imgFlash.image = jeremyGif
        // It's an iPhone
        case .pad: break
        // It's an iPad
        case .unspecified:
            break
        // Uh, oh! What could it be?
        case .tv:
            break
        case .carPlay:
            break
        }
        self.perform(#selector(clickLogin), with: nil, afterDelay: 5.0)
        // Do any additional setup after loading the view.
    }

    @objc func clickLogin()
    {
        if let token =  UserDefaults.standard.value(forKey: kToken) as? String
        {
            APP_DELEGATE.initTabbarHome()
        }
        else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tab1 = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(tab1, animated: true)
        }
       
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

}
