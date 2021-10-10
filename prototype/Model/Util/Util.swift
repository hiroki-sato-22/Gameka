//
//  Util.swift
//  prototype
//
//  Created by hiroki sato on 2021/10/05.
//

import Foundation
import UIKit
import RealmSwift

class Util {
    
    func saveCategory(category: Category) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func saveInsentive(insentive: Insentive) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(insentive)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func load() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
}




