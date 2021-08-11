//
//  EditInsentiveViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/24.
//

import UIKit
import RealmSwift

class EditInsentiveViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var textField: UITextField!
    
    let thePicker = UIPickerView()
    
    let dataList = [Int](arrayLiteral: 1,2,3,4,5)
    
    let realm = try! Realm()
    var insentives: Results<Insentive>?
    
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
    func save(insentive: Insentive) {
        do {
            try realm.write {
                realm.add(insentive)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    // MARK: - alert
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "入力内容を確認してください", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    // MARK: - action
    @IBAction func add(_ sender: Any) {
        
        let newCategory = Insentive()
        
        //空判定
        guard let text = goalTextField.text, !text.isEmpty else {
            displayMyAlertMessage(userMessage: "Insentiveを入力してください")
            return
        }
        guard let text = textField.text, !text.isEmpty else {
            displayMyAlertMessage(userMessage: "Pointを選択してください")
            return
        }
        
        newCategory.title = goalTextField.text!
        newCategory.point = Int(textField.text!)!
        
        self.save(insentive: newCategory)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
}


