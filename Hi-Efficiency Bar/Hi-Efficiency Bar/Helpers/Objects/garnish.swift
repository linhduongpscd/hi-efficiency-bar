//
//  garnish.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 10/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class garnish: NSObject {
    var id: Int?
    var ratio: Bool?
    var name: String?
    var isSwitch: Bool?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.ratio = true
        if let val = dict.object(forKey: "garnish") as? NSDictionary
        {
            self.name = val.object(forKey: "name") as? String
        }
        self.isSwitch = true
    }
}
