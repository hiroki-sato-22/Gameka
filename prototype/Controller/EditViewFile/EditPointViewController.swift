//
//  PointViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/26.
//

import UIKit
import Instructions


class EditPointViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstCustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        self.tableView.tableFooterView = UIView()
       
        addNumberPadDoneButton()
//        self.coachMarksController.dataSource = self
//        firstLaunch()
        isModalInPresentation = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        cell.textField.text = String(savedNumber)
    }
    
    
//    func firstLaunch() {
//        let launchPoint = UserDefaults.standard.bool(forKey: "launchPoint")
//        if launchPoint == true {
//            return
//        } else {
//            UserDefaults.standard.set(true, forKey: "launchPoint")
//            self.coachMarksController.start(in: .window(over: self))
//        }
//    }
    
    
    
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
    
    @objc func cencelAction(){
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        cell.textField.resignFirstResponder()
    }
    
    // MARK: - data
    func addNumberPadDoneButton(){
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! FirstCustomCell
        let toolbar: UIToolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(title: "完了",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneAction))
        let cancel = UIBarButtonItem(title: "戻る",
                                     style: .done,
                                     target: self,
                                     action: #selector(cencelAction))
        toolbar.items = [cancel, space, done]
        toolbar.sizeToFit()
        cell.textField.inputAccessoryView = toolbar
        cell.textField.keyboardType = .numberPad
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - instructions
//extension EditPointViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
//    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
//
//
//        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
//            withArrow: true,
//            arrowOrientation: coachMark.arrowOrientation
//        )
//
//        switch index {
//        case 0:
//            coachViews.bodyView.hintLabel.text = "数字をタップで所持ポイントを編集できます"
//            coachViews.bodyView.nextLabel.text = "OK"
//
//        default:
//            break
//
//        }
//
//
//        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
//    }
//
//
//    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
//        let index2 = IndexPath(row: 0, section: 0)
//        let cell = self.tableView.cellForRow(at: index2) as! FirstCustomCell
//        let highlightViews: Array<UIView> = [
//            cell.textField
//        ]
//
//        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
//    }
//
//    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
//        return 1
//    }
//
//
//}

extension EditPointViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FirstCustomCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.label.text = "所持ポイント"
        return cell
    }
}

