//
//  EditViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/22.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backView: UIView!
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 10
    }
    
    // MARK: - data
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    
    // MARK: - alert
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - action
    @IBAction func add(_ sender: Any) {
        
        let newCategory = Category()
        
        guard let text = textField.text, !text.isEmpty else {
            self.displayMyAlertMessage(userMessage: "Goalを入力してください")
            return
        }
        
        newCategory.name = textField.text!
        self.save(category: newCategory)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}


