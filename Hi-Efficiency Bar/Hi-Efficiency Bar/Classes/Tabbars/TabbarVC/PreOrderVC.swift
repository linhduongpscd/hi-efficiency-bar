//
//  PreOrderVC.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class PreOrderVC: UIViewController {

    @IBOutlet weak var tblOrder: UITableView!
    var tableViewCells = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrder.register( UINib(nibName: "HeaderPreOrderCell", bundle: nil), forCellReuseIdentifier: "HeaderPreOrderCell")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
        // Do any additional setup after loading the view.
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell  = tableViewCells.object(at: indexPath.row) as? HeaderPreOrderCell
        {
            if cell.isMore
            {
                return 455
            }
            else{
                return 315
            }
        }
        return 315
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "HeaderPreOrderCell") as! HeaderPreOrderCell
        cell.tapShowMoreHeader = { [] in
            tableView.reloadData()
        }
        if !tableViewCells.contains(cell) {
            tableViewCells.add(cell)
        }
        return cell
    }
}
