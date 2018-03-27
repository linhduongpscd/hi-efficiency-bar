//
//  HeaderSearchReusable.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 27/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class HeaderSearchReusable: UICollectionReusableView {
     var tapSectionSearch: (() ->())?
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func doSection(_ sender: Any) {
        self.tapSectionSearch?()
    }
}
