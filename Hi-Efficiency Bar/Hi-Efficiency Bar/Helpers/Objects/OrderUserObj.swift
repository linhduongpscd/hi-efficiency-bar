//
//  OrderUserObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 20/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class OrderUserObj: NSObject {
    var id: Int?
    var creation_date: String?
    var amount: Double?
    var arrProducts = [ProductObj]()
    var isLoadMore: Bool
    var user: NSDictionary?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.creation_date = dict["creation_date"] as? String
        self.amount = dict["amount"] as? Double
        if let products = dict["products"] as? NSArray
        {
            print(products)
            for item in products
            {
                let val = item as! NSDictionary
                self.arrProducts.append(ProductObj.init(dict: val))
            }
        }
        if let user = dict["user"] as? NSDictionary
        {
            self.user = user
        }
       
        isLoadMore = false
    }
}
