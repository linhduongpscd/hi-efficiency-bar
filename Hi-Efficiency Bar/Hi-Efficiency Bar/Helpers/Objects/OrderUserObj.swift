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
    var qr_code: String?
    var tray_number: Int?
    var user: NSDictionary?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.creation_date = dict["creation_date"] as? String
        self.qr_code = dict["qr_code"] as? String
         self.tray_number = dict["tray_number"] as? Int
        if let  amount = dict["amount"] as? Double
        {
            self.amount = amount
        }
        else if let  amount = dict["amount"] as? String
        {
            self.amount = Double(amount)
        }
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
