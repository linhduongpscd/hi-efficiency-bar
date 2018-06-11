//
//  CloseBar.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 06/06/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CloseBar: UIView, UITableViewDataSource, UITableViewDelegate {
    var tapRefresh:(() ->())?
    @IBOutlet weak var tblClose: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CloseBar.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        // refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing please wait...", attributes: attributes)
        return refreshControl
    }()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
     
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        refreshControl.endRefreshing()
        self.tapRefresh?()
    }
    func registerCell()
    {
        
        tblClose.register(UINib(nibName: "CloseBarCell", bundle: nil), forCellReuseIdentifier: "CloseBarCell")
        tblClose.addSubview(refreshControl)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblClose.dequeueReusableCell(withIdentifier: "CloseBarCell") as! CloseBarCell
        return cell
    }
}
