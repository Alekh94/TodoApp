//
//  Item.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-06-12.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date? 
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
