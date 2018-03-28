//
//  TopLoungeCollect.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 28/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class TopLoungeCollect: UICollectionViewCell {
    var tapCurrentOrder:(() ->())?
    var tapPreOrder:(() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func doCurrentOrder(_ sender: Any) {
        self.tapCurrentOrder?()
    }
    @IBAction func doPreOrder(_ sender: Any) {
        self.tapPreOrder?()
    }
}
