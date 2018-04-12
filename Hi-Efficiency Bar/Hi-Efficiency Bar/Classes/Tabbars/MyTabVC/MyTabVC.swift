//
//  MyTabVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/14/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import MXParallaxHeader
class MyTabVC: BaseViewController {

    @IBOutlet weak var tblMyTab: UITableView!
    @IBOutlet weak var btnMakeMeDrink: TransitionButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tab"
        btnMakeMeDrink.spinnerColor = .white
        self.btnMakeMeDrink.setTitle("MAKE ME A DRINK!", for: .normal)
        //initParalax()
        self.configHideNaviTable(tblMyTab)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func initParalax()
    {
        let profileView = UIView.init()
        profileView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 30)
        tblMyTab.parallaxHeader.delegate = self
        tblMyTab.parallaxHeader.view = profileView
        tblMyTab.parallaxHeader.height = 30
        tblMyTab.parallaxHeader.mode = .fill
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doMakeMeADrink(_ sender: Any) {
        btnMakeMeDrink.startAnimation() // 2: Then start the animation when the user tap the button
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.btnMakeMeDrink.setTitle("", for: .normal)
                self.btnMakeMeDrink.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
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
extension MyTabVC: MXParallaxHeaderDelegate
{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(parallaxHeader.progress)
        if parallaxHeader.progress > 0.0
        {
            self.navigationItem.title = "My Tab"
        }
        else{
            self.navigationItem.title = ""
        }
    }
}
extension MyTabVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 35
        }
        if indexPath.row == 6
        {
            return 316
        }
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "headercell")
            return cell!
        }
        else if indexPath.row == 6
        {
            let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "visacell")
            return cell!
        }
        let cell = self.tblMyTab.dequeueReusableCell(withIdentifier: "MyTabCell") as! MyTabCell
        if indexPath.row == 3
        {
            cell.subLine.isHidden = true
        }
        else
        {
            cell.subLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vc = UIView.init(frame: .zero)
        return vc
    }
}
