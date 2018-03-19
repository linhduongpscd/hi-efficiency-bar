//
//  BaseNaviController.swift
//  projectX
//
//  Created by Colin Ngo on 1/22/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class BaseNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.black
       // self.navigationBar.barTintColor = UIColor.init(patternImage: #imageLiteral(resourceName: "color_navi"))
        self.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.black]
        
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

}
