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
        tableView.delegate = self
        tableView.dataSource = self
        thePicker.delegate = self
        isModalInPresentation = true
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "SecondCustomCell", bundle: nil), forCellReuseIdentifier: "customCell2")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - data
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    // MARK: - alert
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - action
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        let index2 = IndexPath(row: 1, section: 0)
        let cell2 = self.tableView.cellForRow(at: index2) as! SecondCustomCell
        
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newItem = Item()
                    //空判定
                    guard let text = cell.textField.text, !text.isEmpty else {
                        displayMyAlertMessage(userMessage: "タスクを入力してください")
                        return
                    }
                    guard let text = cell2.textField.text, !text.isEmpty else {
                        displayMyAlertMessage(userMessage: "獲得ポイントを選択してください")
                        return
                    }
                    
                    newItem.title = cell.textField.text!
                    newItem.getPoint = Int(cell2.textField.text!)!
                    
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

// MARK: - pickerView
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
        
        let index2 = IndexPath(row: 1, section: 0)
        let cell2 = self.tableView.cellForRow(at: index2) as! SecondCustomCell
        
        cell2.textField.text = String(dataList[row])
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
            cell.label.text = "タスク"

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! SecondCustomCell
            cell.textField.inputView = thePicker
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
        
    }
}
