//  Sabah Naveed
//  Category.swift
//  Todoey
//
//  Created by Sabah Naveed on 3/19/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = UIColor.randomFlat().hexValue()
    
    let items = List<Item>()  //defines the forward relationship
}
