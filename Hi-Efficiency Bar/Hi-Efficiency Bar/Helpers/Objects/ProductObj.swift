//
//  ProductObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 20/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class ProductObj: NSObject {
    var id: Int?
    var name: String?
    var image: String?
    var price: Double?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.price = dict["price"] as? Double
    }
}
