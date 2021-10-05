//
//  EditInsentiveViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/24.
//

import UIKit
import RealmSwift

class EditInsentiveViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataList = [Int](arrayLiteral: 1,2,3,4,5)
    var pickerValue:Int = 1
    let realm = try! Realm()
    var insentives: Results<Insentive>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTalbeView()
        isModalInPresentation = true
        hideKeyboardWhenTappedAround()
    }
    
    func setTalbeView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "PickerViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
    func save(insentive: Insentive) {
        do {
            try realm.write {
                realm.add(insentive)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - action
    @IBAction func done(_ sender: Any) {
        
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        let newCategory = Insentive()
        
        guard let text = cell.textField.text, !text.isEmpty else {
            displayMyAlertMessage(userMessage: "ご褒美を入力してください")
            return
        }
        
        newCategory.title = cell.textField.text!
        newCategory.point = pickerValue
        
        self.save(insentive: newCategory)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditInsentiveViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
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

extension EditInsentiveViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
}

extension EditInsentiveViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FirstCustomCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = .secondarySystemBackground
            cell.textField.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! PickerViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.picker.delegate = self
            cell.picker.dataSource = self
            cell.backgroundColor = .secondarySystemBackground
            cell.label.text = "消費ポイント"
            
            return cell
        }
        
    }
}


