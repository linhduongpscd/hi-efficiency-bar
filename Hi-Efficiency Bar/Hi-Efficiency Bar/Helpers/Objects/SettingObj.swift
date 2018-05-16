//
//  SettingObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 10/05/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class SettingObj: NSObject {
    var bar_status: Int?
    var free: Int?
    var fee_unit_view: String?
    var tax: Int?
    init(dict: NSDictionary) {
        if let bar = dict["bar_status"] as? Int
        {
             self.bar_status = bar
        }
        else if let bar = dict["bar_status"] as? String
        {
            self.bar_status = Int(bar)
        }
        if let free = dict["fee"] as? Int
        {
            self.free = free
        }
        else if let free = dict["fee"] as? String
        {
            self.free = Int(free)
        }
        if let tax = dict["tax"] as? Int
        {
            self.tax = tax
        }
        else if let tax = dict["tax"] as? String
        {
            self.tax = Int(tax)
        }
        self.fee_unit_view = dict["fee_unit_view"] as? String
        print(self.tax)
         print(self.bar_status)
    }
}
