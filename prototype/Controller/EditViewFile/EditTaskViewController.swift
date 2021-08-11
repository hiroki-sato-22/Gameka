//
//  EditSmallTaskViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/23.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var textField: UITextField!
    
    let thePicker = UIPickerView()
    let dataList = [Int](arrayLiteral: 1,2,3,4,5)
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        textField.inputView = thePicker
        backView.layer.cornerRadius = 10
    }
    
    
    // MARK: - pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataList[row])
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = String(dataList[row])
    }
    
    // MARK: - data
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    // MARK: - alert
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - action
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newItem = Item()
                    //空判定
                    guard let text = goalTextField.text, !text.isEmpty else {
                        displayMyAlertMessage(userMessage: "Small Goalを入力してください")
                        return
                    }
                    guard let text = textField.text, !text.isEmpty else {
                        displayMyAlertMessage(userMessage: "Pointを選択してください")
                        return
                    }
                    
                    newItem.title = goalTextField.text!
                    newItem.getPoint = Int(textField.text!)!
                    
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
    }
        
    
}
