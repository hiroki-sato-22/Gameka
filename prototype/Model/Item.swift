//
//  Items.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/12.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var getPoint: Int = 0
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
