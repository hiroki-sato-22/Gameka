//
//  EditViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/22.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let util = Util()
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
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
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let newCategory = Category()
        
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        guard let text = cell.textField.text, !text.isEmpty else {
            self.displayMyAlertMessage(userMessage: "カテゴリーを入力してください")
            return
        }
        
        newCategory.name = cell.textField.text!
        util.saveCategory(category: newCategory)

        util.load()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
}

extension EditViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FirstCustomCell
        cell.textField.delegate = self
        cell.textField.backgroundColor = .clear
        cell.backgroundColor = .secondarySystemBackground
        
        return cell
    }
    
}
