//
//  CurrentOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/17/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import FBSDKShareKit
class CurrentOrderVC: BaseViewController  {

    @IBOutlet weak var tblCurrent: UITableView!
    var currentPage = 0
    var isLoadWS = false
      var websocket = WebSocket.init()
    var userOrderObj = OrderUserObj.init(dict: NSDictionary.init())
    var blurView = BlurView.init(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCurrent.register(UINib(nibName: "CurrentOrderCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderCell")
         self.tblCurrent.register(UINib(nibName: "FooterCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "FooterCurrentOrderCell")
        self.tblCurrent.register(UINib(nibName: "HeaderCurrentOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderCurrentOrderCell")
         self.tblCurrent.register(UINib(nibName: "CurrentOrderSliceCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderSliceCell")
        //self.initpalalax()
        self.fetchCurrentOrder()
        self.configHideNaviTable(tblCurrent)
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
            //self.initpalalax()
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
        
       // tblCurrent.parallaxHeader.delegate = self
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
        self.navigationController?.isNavigationBarHidden = false
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
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = UIScreen.main.bounds
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        
        return blurEffectView
    }()
    
    @IBAction func doCurrentOrder(_ sender: Any) {

         blurView = Bundle.main.loadNibNamed("BlurView", owner: self, options: nil)?[0] as! BlurView
        blurView.frame = UIScreen.main.bounds
        blurView.userOrderObj = self.userOrderObj
        blurView.registerBlurView()
        blurView.tapClose = { [] in
            UIView.animate(withDuration: 0.25, animations: {
                self.blurView.alpha = 0.0
            }, completion: { (success) in
                self.blurView.removeFromSuperview()
            })
        }
        visualEffectView.alpha = 1.0
        blurView.subContent.addSubview(self.visualEffectView)
        APP_DELEGATE.window?.addSubview(blurView)
        self.blurView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 1.0
        }, completion: { (success) in
        })
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if !isLoadWS
        {
            return 0
        }
        if section == 0
        {
            return 1
        }
        if userOrderObj.arrProducts.count == 0
        {
            return 0
        }
       let obj = userOrderObj.arrProducts[currentPage]
        return obj.arringredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 195 + (UIScreen.main.bounds.size.width - 320)
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
             let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "CurrentOrderSliceCell") as! CurrentOrderSliceCell
            cell.registerCell()
            cell.arrProducts = self.userOrderObj.arrProducts
            cell.collectionView.reloadData()
            if self.userOrderObj.arrProducts.count > 0
            {
                let obj = self.userOrderObj.arrProducts[0]
                cell.lblName.text = obj.name
            }
            cell.tapHeaderMainBar = { [] in
                self.currentPage = cell.currentDot
                self.tblCurrent.reloadData()
            }
            return cell
        }
        
        
        let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "CurrentOrderCell") as! CurrentOrderCell
        let obj = userOrderObj.arrProducts[currentPage]
        print(obj.arringredients.count)
        let item = obj.arringredients[indexPath.row]
        cell.lblName.text = item.name
        if item.ratio != nil
        {
            if item.unit_view != nil
            {
                cell.lblPart.text = "\(item.ratio!) \(item.unit_view!)"
            }
            else{
                cell.lblPart.text = "\(item.ratio!)"
            }
        }
        else{
             cell.lblPart.text = ""
        }
        
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
        if  section == 0 {
            return 0
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0
        {
            return UIView.init(frame: .zero)
        }
         let cell = self.tblCurrent.dequeueReusableCell(withIdentifier: "FooterCurrentOrderCell") as! FooterCurrentOrderCell
        cell.doShareFacebook = { [] in
            
            let obj = self.userOrderObj.arrProducts[self.currentPage]
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
        if section == 0
        {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0
        {
            return UIView.init(frame: .zero)
        }
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


