//
//  MyTabVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MyTabVC: UIViewController {

    @IBOutlet weak var tblMyTab: UITableView!
    @IBOutlet weak var btnMakeMeDrink: TransitionButton!
    @IBOutlet weak var scrollPage: UIScrollView!
    //var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tab"
        btnMakeMeDrink.spinnerColor = .white
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
        //self.shyNavBarManager.scrollView = scrollPage
       // self.shyNavBarManager.extensionView = nil
         //hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollPage)
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //hidingNavBarManager?.viewWillAppear(animated)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        hidingNavBarManager?.viewDidLayoutSubviews()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        hidingNavBarManager?.viewWillDisappear(animated)
//    }
//    
//    // MARK: UITableViewDelegate
//    
//    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        //hidingNavBarManager?.shouldScrollToTop()
//        
//        return true
//    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doMakeMeADrink(_ sender: Any) {
        btnMakeMeDrink.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(2) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnMakeMeDrink.setTitle("", for: .normal)
                self.btnMakeMeDrink.setImage(#imageLiteral(resourceName: "ic_check"), for: .normal)
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnMakeMeDrink.stopAnimation(animationStyle: .shake, completion: {
                    
                    
                })
                self.perform(#selector(self.actionTabbar), with: nil, afterDelay: 1.5)
            })
        })
    }
    
    @objc func actionTabbar()
    {
        let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
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

extension MyTabVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "MyTabCell") as! MyTabCell
        return cell
    }
}
