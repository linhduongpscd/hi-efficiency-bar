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
    }
    
    func configHideNaviTable(_ table: UITableView)
    {
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: table)
    }
    
    func configHideNaviScroll(_ scroll: UIScrollView)
    {
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scroll)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
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


