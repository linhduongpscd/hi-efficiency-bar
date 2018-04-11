//
//  DrinkObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 06/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class DrinkObj: NSObject {
    var category: NSDictionary?
    var creation_date: String?
    var creator: String?
    var glass: NSDictionary?
    var id: Int?
    var image: String?
    var image_background: String?
    var is_favorite: Bool?
    var is_have_ice: Bool?
    var key_word: String?
    var name: String?
    var ingredients: NSArray?
    var garnishes: NSArray?
    init(dict: NSDictionary) {
        self.category = dict["category"] as? NSDictionary
        self.creation_date = dict["creation_date"] as? String
        self.creator = dict["creator"] as? String
        self.glass = dict["glass"] as? NSDictionary
        self.id = dict["id"] as? Int
        self.image = dict["image"] as? String
        self.image_background = dict["image_background"] as? String
        self.is_favorite = dict["is_favorite"] as? Bool
        self.is_have_ice = dict["is_have_ice"] as? Bool
        self.key_word = dict["key_word"] as? String
        self.name = dict["name"] as? String
        self.ingredients = dict["ingredients"] as? NSArray
        self.garnishes = dict["garnishes"] as? NSArray
    }
}
