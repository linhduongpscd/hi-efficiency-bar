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
    var idProduct: Int?
    var image: String?
    var price: Double?
    var arringredients = [IngredientCusObj]()
    var status: Int?
    init(dict: NSDictionary) {
       
        if let val = dict["drink"] as? NSDictionary
        {
           self.idProduct = val["id"] as? Int
            self.name = val["name"] as? String
            self.image = val["image"] as? String
            
            if let ingredients = val["ingredients"] as? NSArray
            {
                for recod in ingredients
                {
                    arringredients.append(IngredientCusObj.init(dict: recod as! NSDictionary))
                }
                
            }
        }
        if let  amount = dict["amount"] as? Double
        {
            self.price = amount
        }
        else if let  amount = dict["amount"] as? String
        {
            self.price = Double(amount)
        }
         self.id = dict["id"] as? Int
        if let status = dict["status"] as? Int
        {
            self.status = status
        }
       
       
    }
}
