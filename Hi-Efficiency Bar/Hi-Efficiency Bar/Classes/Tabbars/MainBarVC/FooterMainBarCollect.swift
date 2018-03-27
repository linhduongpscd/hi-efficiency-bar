//
//  FooterMainBarCollect.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 3/15/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class FooterMainBarCollect: UICollectionReusableView {
    var tapShowMore: (() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func doShowMore(_ sender: Any) {
        self.tapShowMore?()
    }
}
