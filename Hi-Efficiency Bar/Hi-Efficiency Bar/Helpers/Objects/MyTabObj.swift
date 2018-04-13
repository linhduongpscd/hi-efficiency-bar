//
//  MyTabObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 13/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MyTabObj: NSObject {
    var id: Int?
    var name: String?
    var image: String?
    var price: Int?
    var ingredients: NSArray?
    var quantity: Int?
    init(dict: NSDictionary) {
        if let val = dict["drink"] as? NSDictionary
        {
            self.name  = val["name"] as? String
            self.image  = val["image"] as? String
            self.price  = val["price"] as? Int
            self.ingredients  = val["ingredients"] as? NSArray   
        }
        self.id  = dict["id"] as? Int
         self.quantity = dict["quantity"] as? Int
    }
}
