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
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.backgroundColor = .systemBackground
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "PickerViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
        
//        if row == 0 {
//            pickerData = 1
//        } else if row == 1 {
//            pickerData = 2
//        } else if row == 2 {
//            pickerData = 3
//        } else if row == 3 {
//            pickerData = 4
//        } else if row == 4 {
//            pickerData = 5
//        }
        
        pickerValue = dataList[row]

        
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
