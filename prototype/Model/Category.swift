//
//  Category.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/12.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
