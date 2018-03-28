//
//  CurrentOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CurrentOrderVC: UIViewController  {

    @IBOutlet weak var tblCurrent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCurrent.register(UINib(nibName: "CurrentOrderCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
         self.tblCurrent.register(UINib(nibName: "FooterCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "FooterCurrentOrderCell")
        self.tblCurrent.register(UINib(nibName: "HeaderCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderCurrentOrderCell")
        
        self.initpalalax()
        // Do any additional setup after loading the view.
    }
    func initpalalax()
    {
        let headerView = Bundle.main.loadNibNamed("HeaderCustomOrder", owner: self, options: nil)?[0] as! HeaderCustom
        headerView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 195 + (UIScreen.main.bounds.size.width - 320))
        headerView.isListOrder = true
        headerView.registerCell()
        tblCurrent.parallaxHeader.view = headerView
        tblCurrent.parallaxHeader.height = 195 + (UIScreen.main.bounds.size.width - 320)
        tblCurrent.parallaxHeader.mode = .fill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
    }
  
}

extension CurrentOrderVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
        if indexPath.row == 0 {
            cell.spaceTop.isHidden = true
        }
        else{
            cell.spaceTop.isHidden = false
        }
        if indexPath.row == 2 {
            cell.subContent.backgroundColor =  UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0)
            cell.spaceButtom.backgroundColor = UIColor.lightGray
            cell.doTimeLine.backgroundColor = UIColor.lightGray
        }
        else{
            cell.subContent.backgroundColor = UIColor.white
            cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "FooterCurrentOrderCell") as! FooterCurrentOrderCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "HeaderCurrentOrderCell") as! HeaderCurrentOrderCell
        return cell.contentView
    }
}
