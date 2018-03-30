//
//  QuickSearchCollect.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 27/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class QuickSearchCollect: UICollectionViewCell, UITextFieldDelegate, TagsDelegate {
    var taptags: (() ->())?
    var tapSearchQuickly: (() ->())?
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var tags: TagsView!
    var stringTag = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        tags.delegate = self
        // Initialization code
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfSearch.resignFirstResponder()
        return true
    }
    
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        CommonHellper.animateViewSmall(view: tagButton)
        stringTag = self.tags.tagTextArray[tagButton.index]
        self.perform(#selector(self.viewDetail), with: nil, afterDelay: 0.8)
    }
    
    @objc func viewDetail()
    {
        self.taptags?()
        
    }

    @IBAction func doSearchtag(_ sender: Any) {
        self.tapSearchQuickly?()
    }
}

