//
//  AppDelegate.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Stripe
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    var tabbarController: UITabBarController!
    var drinkObj: DrinkObj?
    var isRedirectMyTab = false
    var settingObj =  SettingObj.init(dict: NSDictionary.init())
    var mainBarVC: MainBarVC?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(1)
        self.initFlash()
        STPPaymentConfiguration.shared().publishableKey = KEY_STRIPE
        //self.initTabbarHome()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.hasPrefix("fb") == true {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            
        }
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a stripe url – do whatever url handling your app
            // normally does, if any.
        }
        return false
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
    
    // This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a stripe url – do whatever url handling your app
                    // normally does, if any.
                }
            }
        }
        return false
    }

    func initFlash()
    {
        let storyboard = UIStoryboard.init(name: "Tabbar", bundle: nil)
        let tab1 = storyboard.instantiateViewController(withIdentifier: "FlashVC") as! FlashVC
        let navTab1 = BaseNaviController(rootViewController: tab1)
        navTab1.isNavigationBarHidden = true
        window?.rootViewController = navTab1
        window?.makeKeyAndVisible()
    }
    func initLogin()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tab1 = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let navTab1 = BaseNaviController(rootViewController: tab1)
        navTab1.isNavigationBarHidden = true
        window?.rootViewController = navTab1
        window?.makeKeyAndVisible()
    }
    func initTabbarHome()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tab1 = storyboard.instantiateViewController(withIdentifier: "MainBarVC") as! MainBarVC
        let navTab1 = BaseNaviController(rootViewController: tab1)
        navTab1.tabBarItem.image = #imageLiteral(resourceName: "tab_main1").withRenderingMode(.alwaysOriginal)
        navTab1.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_main2").withRenderingMode(.alwaysOriginal)
        navTab1.tabBarItem.title = "Main Bar"
        navTab1.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        navTab1.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB1], for: .selected)
        
        let tab2 = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        let navTab2 = BaseNaviController(rootViewController: tab2)
        navTab2.tabBarItem.image = #imageLiteral(resourceName: "tab_search1").withRenderingMode(.alwaysOriginal)
        navTab2.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_search2").withRenderingMode(.alwaysOriginal)
        navTab2.tabBarItem.title = "Search"
        navTab2.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        navTab2.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB2], for: .selected)
        
        let tab3 = storyboard.instantiateViewController(withIdentifier: "CustomVC") as! CustomVC
        let navTab3 = BaseNaviController(rootViewController: tab3)
        navTab3.tabBarItem.image = #imageLiteral(resourceName: "tab_custom1").withRenderingMode(.alwaysOriginal)
        navTab3.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_custom2").withRenderingMode(.alwaysOriginal)
        navTab3.tabBarItem.title = "Custom"
        navTab3.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        navTab3.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB3], for: .selected)
        
        let tab4 = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MyTabVC") as! MyTabVC
        let navTab4 = BaseNaviController(rootViewController: tab4)
        navTab4.tabBarItem.image = #imageLiteral(resourceName: "tab_mytab1").withRenderingMode(.alwaysOriginal)
        navTab4.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_mytab2").withRenderingMode(.alwaysOriginal)
        navTab4.tabBarItem.title = "My Tab"
        navTab4.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        navTab4.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB4], for: .selected)
        
        let tab5 = storyboard.instantiateViewController(withIdentifier: "LoungeTabbarVC") as! LoungeTabbarVC
        let navTab5 = BaseNaviController(rootViewController: tab5)
        navTab5.tabBarItem.image = #imageLiteral(resourceName: "tab_lounge1").withRenderingMode(.alwaysOriginal)
        navTab5.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_lounge2").withRenderingMode(.alwaysOriginal)
        navTab5.tabBarItem.title = "Lounge"
        navTab5.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.UNSELECT], for: .normal)
        navTab5.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: COLOR_TABBAR.TAB5], for: .selected)
        
        tabbarController = UITabBarController.init()
        tabbarController.delegate = self
        tabbarController.tabBar.barTintColor = UIColor.white
        tabbarController.viewControllers = [navTab1, navTab2, navTab3, navTab4, navTab5]
        
        let navTabbar = BaseNaviController(rootViewController: tabbarController!)
        navTabbar.isNavigationBarHidden = true
        window?.rootViewController = navTabbar
        window?.makeKeyAndVisible()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       
    }
    
}
