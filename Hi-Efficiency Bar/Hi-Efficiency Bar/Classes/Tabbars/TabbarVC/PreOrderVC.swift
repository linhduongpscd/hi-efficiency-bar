//
//  PreOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class PreOrderVC: BaseViewController {

    @IBOutlet weak var tblOrder: UITableView!
    var offset = 0
    var arrOrders = [OrderUserObj]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(PreOrderVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        // refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing please wait...", attributes: attributes)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrder.register( UINib(nibName: "HeaderPreOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderPreOrderCell")
        self.navigationController?.isNavigationBarHidden = false
        self.configHideNaviTable(tblOrder)
        self.fectAllOrder(true)
        self.tblOrder.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        self.fectAllOrder(false)
    }
    
    func fectAllOrder(_ isLoading: Bool)
    {
        if isLoading
        {
            CommonHellper.showBusy()
        }
        
        ManagerWS.shared.fetchListUserOrder(offset: offset) { (success, arrs) in
            self.refreshControl.endRefreshing()
            self.arrOrders = arrs!
            self.tblOrder.reloadData()
            CommonHellper.hideBusy()
        }
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension PreOrderVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOrders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let userOrderObj = arrOrders[indexPath.row]
        if userOrderObj.isLoadMore
        {
            return 175 + CGFloat(userOrderObj.arrProducts.count * 70)
        }
        else{
            if userOrderObj.arrProducts.count > 2
            {
                return 315
            }
            else{
                return 140 + CGFloat(userOrderObj.arrProducts.count * 70)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "HeaderPreOrderCell") as! HeaderPreOrderCell
        cell.userOrderObj = arrOrders[indexPath.row]
        cell.lblOrder.text = "Order #\(cell.userOrderObj.id!)"
        if cell.userOrderObj.amount != nil
        {
            cell.lblPrice.text = String.init(format: "$%0.2f", cell.userOrderObj.amount!)
        }
      
        cell.tapShowMoreHeader = { [] in
            tableView.reloadData()
        }
        cell.tapProduct = { [] in
            let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailVC") as! ViewDetailVC
            vc.idProduct = self.arrOrders[indexPath.row].arrProducts[cell.indexPathSelect].idProduct!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.tapShowCurrentOrder = { [] in
            //let vc = UIStoryboard.init(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
            //self.navigationController?.pushViewController(vc, animated: true)
            CommonHellper.showBusy()
            ManagerWS.shared.reorder(order_id: cell.userOrderObj.id!, complete: { (success, error) in
                CommonHellper.hideBusy()
                if success!
                {
                    self.tabBarController?.selectedIndex = 3
                }
                else{
                    self.showAlertMessage(message: error!)
                }
            })
        }
        cell.tapReorderProduct = {[] in
            self.tabBarController?.selectedIndex = 3
        }
        if cell.userOrderObj.creation_date != nil
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if  dateFormatter.date(from: cell.userOrderObj.creation_date!) != nil {
                let date = dateFormatter.date(from: cell.userOrderObj.creation_date!)
                cell.lblTimeAgo.text = timeAgoSince(date!)
            } else {
                // invalid format
                print("ERROR")
            }
            
        }
        else{
            cell.lblTimeAgo.text = ""
        }
        return cell
    }
}
