//
//  HeaderPreOrderCell.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/19/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderPreOrderCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblOrder: UITableView!
    override func awakeFromNib() {
         tblOrder.register( UINib(nibName: "PreOrderCell", bundle: nil), forCellReuseIdentifier: "PreOrderCell")
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOrder.dequeueReusableCell(withIdentifier: "PreOrderCell") as! PreOrderCell
        if indexPath.row == 1 {
            cell.subLine.isHidden = true
        }
        else{
             cell.subLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: .zero)
        return view
    }
}
