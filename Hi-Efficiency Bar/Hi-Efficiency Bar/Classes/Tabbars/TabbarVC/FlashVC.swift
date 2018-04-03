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
        let jeremyGif = UIImage.gifImageWithName("Speed3")
        imgFlash.image = jeremyGif
        self.perform(#selector(clickLogin), with: nil, afterDelay: 4.6)
        // Do any additional setup after loading the view.
    }

    @objc func clickLogin()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tab1 = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(tab1, animated: true)
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
