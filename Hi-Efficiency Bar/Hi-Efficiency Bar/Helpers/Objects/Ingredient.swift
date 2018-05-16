//
//  Ingredient.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 11/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    var id: Int?
    var image: String?
    var name: String?
    var price: Int?
    var quanlity_of_bottle: Int?
    var type: NSDictionary?
    var brand: NSDictionary?
    var bgColor: UIColor?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.image = dict["image"] as? String
        self.name = dict["name"] as? String
        self.price = dict["price"] as? Int
        self.quanlity_of_bottle = dict["quanlity_of_bottle"] as? Int
        self.type = dict["type"] as? NSDictionary
        self.brand = dict["brand"] as? NSDictionary
        self.bgColor =  CommonHellper.ramColorViewDetail()
    }
}
