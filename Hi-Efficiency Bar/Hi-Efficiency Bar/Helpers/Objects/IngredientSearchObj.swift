//
//  IngredientSearchObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 18/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class IngredientSearchObj: NSObject {
    var id: Int?
    var image: String?
    var name: String?
    var isSeleled: Bool?
    var type_search: Int?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.image = dict["image"] as? String
        self.name = dict["name"] as? String
         self.type_search = dict["type_search"] as? Int
        self.isSeleled = false
    }
}
