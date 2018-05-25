//
//  IngredientCusObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 17/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class IngredientCusObj: NSObject {
     var id: Int?
    var ratio: Int?
    var name: String?
    var unit: Int?
    var unit_view: String?
    var value: Double?
    init(dict: NSDictionary) {
        self.ratio = dict["ratio"] as? Int
        self.unit = dict["unit"] as? Int
        self.unit_view = dict["unit_view"] as? String
        if let val = dict["ingredient"] as? NSDictionary
        {
            self.name = val["name"] as? String
            self.id = val["id"] as? Int
        }
    }
}
