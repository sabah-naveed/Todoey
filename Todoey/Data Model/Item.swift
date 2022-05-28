//  Sabah Naveed
//  Item.swift
//  Todoey
//
//  Created by Sabah Naveed on 3/19/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //"items" refers to the forward relationship
}
