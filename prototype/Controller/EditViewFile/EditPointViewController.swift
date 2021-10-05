//
//  PointViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/26.
//

import UIKit

class EditPointViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    let array = [Int](0...200)
    let userDefaults = UserDefaults.standard
    var pickerValue:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTableView()
        isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! LargePickerCell
        cell.picker.selectRow(Int(pickerValue - 1), inComponent: 0, animated: true)
    }
    
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = 100
        tableView.backgroundColor = .systemBackground
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "LargePickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
    }
    
    
    
    // MARK: - objc Action
    @objc func doneAction(){
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        var savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        //textFieldをtapで編集して値をsavedNUmberに入れる
        guard let text = cell.textField.text, !text.isEmpty else {
            self.displayMyAlertMessage(userMessage: "ポイントを入力してください")
            return
        }
        
        savedNumber = Int(cell.textField.text!)!
        //currentPointをuserDefalutsに保存
        UserDefaults.standard.set(savedNumber, forKey: "currentValue")
        cell.textField.resignFirstResponder()
    }
    
  
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        
        userDefaults.set(pickerValue, forKey: "currentValue")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditPointViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! LargePickerCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.picker.delegate = self
        cell.picker.dataSource = self
        cell.backgroundColor = .secondarySystemBackground
        
        return cell
    }
    
}

extension EditPointViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return String(array[row])
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        pickerValue = array[row]
    }
    
}
