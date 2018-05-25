//
//  GlassObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 10/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class GlassObj: NSObject {

    var id: Int?
    var unit_view: String?
    var name: String?
    var image: String?
    var size: Int?
    var unit: Int?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.unit = dict["unit"] as? Int
        self.unit_view = dict["unit_view"] as? String
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.size = dict["size"] as? Int
    }
}
