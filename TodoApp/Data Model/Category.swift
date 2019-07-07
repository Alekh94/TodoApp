//
//  Category.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-06-12.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
