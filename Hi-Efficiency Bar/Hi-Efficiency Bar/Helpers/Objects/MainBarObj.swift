//
//  MainBarObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 04/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class MainBarObj: NSObject {
    var id: Int?
    var name: String?
    var image: String?
    var slug: String?
    var arrIngredients = [Ingredient]()
    var bgColor: UIColor?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.slug = dict["slug"] as? String
        if let arrs = dict["ingredient_brands"] as? NSArray
        {
            for item in arrs
            {
                self.arrIngredients.append(Ingredient.init(dict: item as! NSDictionary))
            }
        }
        self.bgColor =  CommonHellper.ramColorViewDetail()
    }
}
