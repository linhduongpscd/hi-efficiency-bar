//
//  CurrentOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import FBSDKShareKit
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
                self.open()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        websocket.close()
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
        if userOrderObj.id != nil{
            self.open()
        }
    }
  
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func resetObjToProduct(value: String)
    {
        let result = self.convertToDictionary(text: value)
        if let payload = result!["payload"] as? NSDictionary
        {
            if let data = payload["data"] as? NSDictionary
            {
                print(data)
                if let id = data["id"] as? Int{
                    print(id)
                    let userOrderObj = OrderUserObj.init(dict: data)
                    self.userOrderObj.arrProducts = userOrderObj.arrProducts
                     self.tblCurrent.reloadData()
                }
               
               
            }
        }
    }
   
}

extension CurrentOrderVC: WebSocketDelegate
{
    func webSocketOpen() {
        print("OPEN")
        //print("{\"stream\":\"orders\",\"payload\":{\"action\":\"subscribe\",\"pk\":\"\(userOrderObj.id!)\",\"data\":{\"action\":\"update\"}}}")
        websocket.send("{\"stream\":\"orders\",\"payload\":{\"action\":\"subscribe\",\"pk\":\"\(userOrderObj.id!)\",\"data\":{\"action\":\"update\"}}}")
        
    }
    
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool) {
        print("Close \(reason)")
    }
    
    func webSocketMessageData(_ data: Data) {
        print("DATA  - \(data)")
        
    }
    
    func webSocketMessageText(_ text: String) {
        print("TEXT  \(text)")
        self.resetObjToProduct(value: text)
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
        if userOrderObj.arrProducts.count == 0
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
        
        if obj.status! < 31
        {
            cell.subContent.backgroundColor = UIColor.white
            cell.spaceButtom.backgroundColor = UIColor.lightGray
            cell.doTimeLine.backgroundColor = UIColor.lightGray
            cell.spaceTop.backgroundColor = UIColor.lightGray

        }
        else if obj.status! == 31 ||  obj.status! == 32
        {
           if indexPath.row == obj.arringredients.count - 1
           {
            cell.subContent.backgroundColor = UIColor.white
            cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            cell.spaceTop.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)

           }
           else{
            cell.subContent.backgroundColor = UIColor.white
            cell.spaceButtom.backgroundColor = UIColor.lightGray
            cell.doTimeLine.backgroundColor = UIColor.lightGray
            cell.spaceTop.backgroundColor = UIColor.lightGray
            }
        }
        else if obj.status! == 33
        {
            cell.subContent.backgroundColor = UIColor.white
            cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            cell.spaceTop.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
            
        }
        else{
            if indexPath.row == obj.arringredients.count - 1
            {
                cell.subContent.backgroundColor = UIColor.white
                cell.spaceButtom.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
                cell.doTimeLine.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
                cell.spaceTop.backgroundColor = UIColor.init(red: 72/255.0, green: 181/255.0, blue: 251/255.0, alpha: 1.0)
                
            }
            else{
                cell.subContent.backgroundColor = UIColor.white
                cell.spaceButtom.backgroundColor = UIColor.lightGray
                cell.doTimeLine.backgroundColor = UIColor.lightGray
                cell.spaceTop.backgroundColor = UIColor.lightGray
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !isLoadWS
        {
            return 0
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "FooterCurrentOrderCell") as! FooterCurrentOrderCell
        cell.doShareFacebook = { [] in
            
            let obj = self.userOrderObj.arrProducts[self.currentPage]
            /*FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
            
            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
            dialog.fromViewController = self;
            dialog.content = content;
            dialog.mode = FBSDKShareDialogModeShareSheet;
            [dialog show];*/
            let content = FBSDKShareLinkContent.init()
            if obj.image != nil
            {
                content.contentURL = URL.init(string: obj.image!)
            }
            content.quote = obj.name
            let dialog = FBSDKShareDialog.init()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.show()
        }
        return cell
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


