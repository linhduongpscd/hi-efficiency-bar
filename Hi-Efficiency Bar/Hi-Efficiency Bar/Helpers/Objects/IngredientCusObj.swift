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
    var ratio: Double?
    var name: String?
    var unit: Double?
    var unit_view: String?
    var value: Double?
    init(dict: NSDictionary) {
        self.ratio = dict["ratio"] as? Double
        self.unit = dict["unit"] as? Double
        self.unit_view = dict["unit_view"] as? String
        if let val = dict["ingredient"] as? NSDictionary
        {
            self.name = val["name"] as? String
            self.id = val["id"] as? Int
        }
    }
}
