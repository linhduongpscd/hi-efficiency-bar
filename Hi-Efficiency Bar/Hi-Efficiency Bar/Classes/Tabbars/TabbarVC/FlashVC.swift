//
//  FlashVC.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 03/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyGif
class FlashVC: UIViewController {

    @IBOutlet weak var imgFlash: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            //let jeremyGif = UIImage.gifImageWithName("Speed3")
            //imgFlash.image = jeremyGif
            
            let gif = UIImage(gifName: "Speed3.gif")
            let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
            print(imgFlash.frame.size.height)
            imageview.frame = CGRect(x:0, y:20 , width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 248)
            imageview.delegate = self
            imageview.contentMode = .scaleAspectFit
            view.addSubview(imageview)
            imageview.startAnimatingGif()
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
       // self.perform(#selector(clickLogin), with: nil, afterDelay: 3.5)
        // Do any additional setup after loading the view.
    }

    @objc func clickLogin()
    {
//        if let token =  UserDefaults.standard.value(forKey: kToken) as? String
//        {
//
//            APP_DELEGATE.initTabbarHome()
//        }
//        else{
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let tab1 = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//            self.navigationController?.pushViewController(tab1, animated: true)
//        }
       
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

extension FlashVC : SwiftyGifDelegate {
    
    func gifURLDidFinish(sender: UIImageView) {
        print("gifURLDidFinish")
        
    }
    
    func gifURLDidFail(sender: UIImageView) {
        print("gifURLDidFail")
    }
    
    func gifDidStart(sender: UIImageView) {
        print("gifDidStart")
    }
    
    func gifDidLoop(sender: UIImageView) {
        print("gifDidLoop")
    }
    
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
        if let token =  UserDefaults.standard.value(forKey: kLoginApp) as? String
        {
            print(token)
           // APP_DELEGATE.initTabbarHome()
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tab1 = storyboard.instantiateViewController(withIdentifier: "AgeVerificationVC") as! AgeVerificationVC
            tab1.isLogin = true
            self.navigationController?.pushViewController(tab1, animated: true)
        }
        else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tab1 = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(tab1, animated: true)
        }
    }
}
