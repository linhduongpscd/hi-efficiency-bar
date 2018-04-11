//
//  FooterDetailTag.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 11/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class FooterDetailTag: UICollectionReusableView {
    var tapLoadMore: (() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func doLoadMore(_ sender: Any) {
        self.tapLoadMore?()
    }
}
