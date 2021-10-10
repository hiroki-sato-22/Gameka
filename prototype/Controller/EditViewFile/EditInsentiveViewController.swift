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
    
    let util = Util()
    
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
        tableView.rowHeight = view.bounds.height / 9
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "PickerViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        let newInsentive = Insentive()
        
        guard let text = cell.textField.text, !text.isEmpty else {
            displayMyAlertMessage(userMessage: "ご褒美を入力してください")
            return
        }
        
        newInsentive.title = cell.textField.text!
        newInsentive.point = pickerValue
        
        util.saveInsentive(insentive: newInsentive)
        util.load()
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
            cell.textField.placeholder = "ご褒美"
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


