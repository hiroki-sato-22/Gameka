//
//  EditSmallTaskViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/23.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let util = Util()
    
    let dataList = [Int](arrayLiteral: 1,2,3,4,5)
    var pickerValue:Int = 1
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTableView()
        isModalInPresentation = true
        hideKeyboardWhenTappedAround()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = view.bounds.height / 9
        tableView.backgroundColor = .systemBackground
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "PickerViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newItem = Item()
                    //空判定
                    guard let text = cell.textField.text, !text.isEmpty else {
                        displayMyAlertMessage(userMessage: "タスクを入力してください")
                        
                        return
                    }
                    
                    newItem.title = cell.textField.text!
                    newItem.getPoint = pickerValue
                    
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    
                    self.dismiss(animated: true, completion: nil)
                    util.load()
                }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
    }
    
    
}


extension EditTaskViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
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
        
        pickerValue = dataList[row]
        
        
    }
    
}

extension EditTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
}

extension EditTaskViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FirstCustomCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = .secondarySystemBackground
            cell.textField.delegate = self
            cell.textField.placeholder = "タスク名"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! PickerViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.picker.delegate = self
            cell.picker.dataSource = self
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
        }
        
        
    }
}
