//
//  TabbarVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabbarCus()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Main Bar"
        // Do any additional setup after loading the view.
    }

    func initTabbarCus()
    {
        let tab1UnSelected: UIImage! = #imageLiteral(resourceName: "tab_main1").withRenderingMode(.alwaysOriginal)
        let tab2UnSelected: UIImage! = #imageLiteral(resourceName: "tab_search1").withRenderingMode(.alwaysOriginal)
        let tab3UnSelected: UIImage! = #imageLiteral(resourceName: "tab_custom1").withRenderingMode(.alwaysOriginal)
        let tab4UnSelected: UIImage! = #imageLiteral(resourceName: "tab_mytab1").withRenderingMode(.alwaysOriginal)
        let tab5UnSelected: UIImage! = #imageLiteral(resourceName: "tab_lounge1").withRenderingMode(.alwaysOriginal)
        
        let tab1Selected: UIImage! = #imageLiteral(resourceName: "tab_main2").withRenderingMode(.alwaysOriginal)
        let tab2Selected: UIImage! = #imageLiteral(resourceName: "tab_search2").withRenderingMode(.alwaysOriginal)
        let tab3Selected: UIImage! = #imageLiteral(resourceName: "tab_custom2").withRenderingMode(.alwaysOriginal)
        let tab4Selected: UIImage! = #imageLiteral(resourceName: "tab_mytab2").withRenderingMode(.alwaysOriginal)
        let tab5Selected: UIImage! = #imageLiteral(resourceName: "tab_lounge2").withRenderingMode(.alwaysOriginal)
        
        (tabBar.items![0] ).image = tab1UnSelected
         (tabBar.items![1] ).image = tab2UnSelected
        
        (tabBar.items![2]).image = tab3UnSelected
        
        (tabBar.items![3] ).image = tab4UnSelected
        (tabBar.items![4] ).image = tab5UnSelected
        
        (tabBar.items![0] ).selectedImage = tab1Selected
        (tabBar.items![1] ).selectedImage = tab2Selected
        (tabBar.items![2] ).selectedImage = tab3Selected
        (tabBar.items![3] ).selectedImage = tab4Selected
         (tabBar.items![4] ).selectedImage = tab5Selected
        
        (tabBar.items![0] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        (tabBar.items![1] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        (tabBar.items![2] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        (tabBar.items![3] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        (tabBar.items![4] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
          (tabBar.items![0] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB1], for: .selected)
          (tabBar.items![1] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB2], for: .selected)
          (tabBar.items![2] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB3], for: .selected)
          (tabBar.items![3] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB4], for: .selected)
          (tabBar.items![4] ).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB5], for: .selected)
        
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
