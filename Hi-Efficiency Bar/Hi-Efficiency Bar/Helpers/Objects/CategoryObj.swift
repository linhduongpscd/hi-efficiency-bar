//
//  CategoryObj.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 12/04/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CategoryObj: NSObject {
    var id: Int?
    var image: String?
    var link: String?
    var main_level: Int?
    var name: Int?
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int
         self.image = dict["image"] as? String
         self.link = dict["link"] as? String
         self.main_level = dict["main_level"] as? Int
        self.name = dict["name"] as? Int
    }
}
