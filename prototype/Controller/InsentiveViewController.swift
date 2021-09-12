//
//  InsentiveViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/16.
//

import UIKit
import RealmSwift
import Instructions

class InsentiveViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var pointLabel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let coachMarksController = CoachMarksController()
    let realm = try! Realm()
    var insentives: Results<Insentive>?
    var currentPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.coachMarksController.dataSource = self
        firstLaunch()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
//        self.coachMarksController.start(in: .window(over: self))
    }
    
    func setTableView() {
        tableView.rowHeight = view.frame.height / 9
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        tableView.separatorStyle = .none
       
        self.tableView.tableFooterView = UIView()

    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    
    
    func firstLaunch() {
        let launchInsentive = UserDefaults.standard.bool(forKey: "launchInsentive")
        if launchInsentive == true {
            return
        } else {
            UserDefaults.standard.set(true, forKey: "launchInsentive")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
   
    
    // MARK: - data
    func Calculation(for indexPath: IndexPath) {
        //currentPointに値を入れる
        if let item = insentives?[indexPath.row] {
            
            let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
            
            currentPoint = savedNumber - item.point
            
        }
        //currentPointをuserDefalutsに保存
        UserDefaults.standard.set(currentPoint, forKey: "currentValue")
        //currentPointをnavBarに表示
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let item = insentives?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    
    func save(insentive: Insentive) {
        do {
            try realm.write {
                realm.add(insentive)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        insentives = realm.objects(Insentive.self)
        tableView.reloadData()
    }
    
    // MARK: - alert
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "ご褒美を実行しますか？", message: "OKを選択すると所持ポイントから減算されます", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                //削除メソッド
                self.Calculation(for: indexPath)
            }
        }
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        //Present the alert controller
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    // MARK: - action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToEditInsentives", sender: nil)
    }
    
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
}

// MARK: - tableView delegate
extension InsentiveViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            return 1
        }else {
            return insentives?.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
            cell.label.text = "追加したご褒美をタップで、実行してポイントを減算。または、左ワイプで削除。"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
            cell.nextLabel.isHidden = true
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if let item = insentives?[indexPath.row] {
                
                cell.label.text = item.title
                cell.pointLabel.text = String(item.point)
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }else {
            showDeleteWarning(for: indexPath)
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            if editingStyle == UITableViewCell.EditingStyle.delete {
                updateModel(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return true
    }
}

// MARK: - instructions
extension InsentiveViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: false,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "このボタンでタスクを完了した時の自分へのご褒美を設定できます"
            coachViews.bodyView.separator.isHidden = true
            coachViews.bodyView.background.borderColor = .clear
            
        default:
            break
            
        }
        
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [
            addButton.value(forKey: "view") as! UIView,
        ]
        
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
}

