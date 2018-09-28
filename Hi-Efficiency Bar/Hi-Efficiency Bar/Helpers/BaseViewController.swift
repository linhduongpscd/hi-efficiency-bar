//
//  BaseViewController.swift
//  projectX
//
//  Created by Colin Ngo on 1/22/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var hidingNavBarManager: HidingNavigationBarManager?
    var loadingView = LoadingView.init(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    func configHideNaviScroll(_ collection: UICollectionView)
    {
         hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: collection)
        hidingNavBarManager?.delegate = self
    }
    
    func configHideNaviTable(_ table: UITableView)
    {
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: table)
        hidingNavBarManager?.delegate = self
    }
    
    func configHideNaviScrollVIEW(_ scroll: UIScrollView)
    {
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scroll)
        hidingNavBarManager?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = true
        if APP_DELEGATE.isRedirectMyTab {
            self.tabBarController?.selectedIndex = 3
            APP_DELEGATE.isRedirectMyTab = false
        }
        
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
    
    @objc func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
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
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   
    func addLoadingView()
    {
        loadingView =  Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?[0] as! LoadingView
        loadingView.frame = UIScreen.main.bounds
        APP_DELEGATE.window?.addSubview(loadingView)
    }
    
    func removeLoadingView()
    {
        loadingView.removeFromSuperview()
    }

}


extension BaseViewController: HidingNavigationBarManagerDelegate
{
    func hidingNavigationBarManagerShouldUpdateScrollViewInsets(_ manager: HidingNavigationBarManager, insets: UIEdgeInsets) -> Bool {
        print(insets)
        if #available(iOS 11.0, *) {
            if insets.top == 0
            {
                self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
            }
            else{
                print(insets.top)
                if insets.top > 0
                {
                    self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
                }
                else{
                    self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 24 + insets.top/2)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
                }
                
            }
        } else {
            if insets.top > 44
            {
                self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
            }
            else{
                print(24 + (44/2 - insets.top))
                self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: FONT_APP.AlrightSans_Regular, size: 24 + (insets.top - 44))!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
            }
            // or use some work around
        }
        return true
    }
    
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(_ manager: HidingNavigationBarManager) {
        
    }
    
    func hidingNavigationBarManagerDidChangeState(_ manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        
    }
    
    
}

