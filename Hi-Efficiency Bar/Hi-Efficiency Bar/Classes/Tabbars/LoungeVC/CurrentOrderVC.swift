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
    var currentPage = 0
    var isLoadWS = false
      var websocket = WebSocket.init()
    var userOrderObj = OrderUserObj.init(dict: NSDictionary.init())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCurrent.register(UINib(nibName: "CurrentOrderCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
         self.tblCurrent.register(UINib(nibName: "FooterCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "FooterCurrentOrderCell")
        self.tblCurrent.register(UINib(nibName: "HeaderCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderCurrentOrderCell")
        //self.open()
        self.initpalalax()
        self.fetchCurrentOrder()
        // Do any additional setup after loading the view.
    }
    
    func fetchCurrentOrder()
    {
        ManagerWS.shared.fetchListCurrentOrder { (success, arrs) in
           
            if arrs?.count == 0
            {
                print("NOT FOUND")
            }
            else{
                self.isLoadWS = true
                self.userOrderObj = arrs![0]
            }
            self.initpalalax()
            self.tblCurrent.reloadData()
        }
    }
    func open()
    {
        websocket = WebSocket.init("ws://hiefficiencybar.com:80/")
        websocket.delegate = self
        websocket.open()
    }
    func initpalalax()
    {
        let headerView = Bundle.main.loadNibNamed("HeaderCustomOrder", owner: self, options: nil)?[0] as! HeaderCustom
        headerView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.size.width, height: 195 + (UIScreen.main.bounds.size.width - 320))
        headerView.isListOrder = true
        headerView.registerCell()
        headerView.arrProducts = self.userOrderObj.arrProducts
        headerView.collectionView.reloadData()
        if self.userOrderObj.arrProducts.count > 0
        {
            let obj = self.userOrderObj.arrProducts[0]
            headerView.lblName.text = obj.name
        }
        headerView.tapClick = { [] in
            self.currentPage = headerView.currentDot
            self.tblCurrent.reloadData()
        }
        tblCurrent.parallaxHeader.view = headerView
        tblCurrent.parallaxHeader.height = 195 + (UIScreen.main.bounds.size.width - 320)
        tblCurrent.parallaxHeader.mode = .fill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: Any) {
        // websocket.send(text: "{\"payload\": {\"action\": \"subscribe\", \"response_status\": 200, \"errors\": [], \"data\": {\"action\": \"update\"}, \"request_id\": null}, \"stream\": \"orders\"}")
        
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

extension CurrentOrderVC: WebSocketDelegate
{
    func webSocketOpen() {
        print("OPEN")
        
    }
    
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool) {
        print("Close \(reason)")
    }
    
    func webSocketMessageData(_ data: Data) {
        print("DATA  - \(data)")
        
    }
    
    func webSocketMessageText(_ text: String) {
        print("TEXT  \(text)")
    }
    
    func webSocketPong() {
        print("PONG")
    }
    
    func webSocketError(_ error: NSError) {
        print("ERROR \(error)")
    }
    
    func webSocketEnd(_ code: Int, reason: String, wasClean: Bool, error: NSError?) {
        print("END")
    }
}
extension CurrentOrderVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if !isLoadWS
        {
            return 0
        }
       let obj = userOrderObj.arrProducts[currentPage]
        return obj.arringredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
        let obj = userOrderObj.arrProducts[currentPage]
        print(obj.arringredients.count)
        let item = obj.arringredients[indexPath.row]
        cell.lblName.text = item.name
        cell.lblPart.text = "\(item.ratio!) \(item.unit!)"
        if indexPath.row == 0 {
            cell.bgTranfer.isHidden = false
            cell.spaceTop.isHidden = true
        }
        else{
            cell.bgTranfer.isHidden = true
            cell.spaceTop.isHidden = false
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
        if userOrderObj.user != nil
        {
            if let first_name = userOrderObj.user!["first_name"] as? String
            {
                if let last_name = userOrderObj.user!["last_name"] as? String
                {
                    cell.lblName.text = "By: \(first_name) \(last_name)"
                }
            }
        }
        return cell.contentView
    }
}
