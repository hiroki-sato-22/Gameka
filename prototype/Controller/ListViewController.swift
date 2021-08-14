//
//  ListViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit
import RealmSwift
import Instructions

class ListViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPointDisplay: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let coachMarksController = CoachMarksController()
    var currentPoint = 0
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.coachMarksController.dataSource = self
        firstLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //pointLabelに表示
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        totalPointDisplay.title = String(savedNumber)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.separatorStyle = .none
    }
    
    func firstLaunch() {
        let launchList = UserDefaults.standard.bool(forKey: "launchList")
        if launchList == true {
            return
        } else {
            UserDefaults.standard.set(true, forKey: "launchList")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - data
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    // MARK: - alert
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "タスクを完了しますか？", message: "OKを選択するとポイントが加算されます", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.Calculation(for: indexPath)
            }
        }
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        //Present the alert controller
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToEditSmallTasks", sender: nil)
    }
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditSmallTasks" {
            
            let nav = segue.destination as! UINavigationController
            
            let destinationVC = nav.topViewController as! EditTaskViewController
            destinationVC.selectedCategory = self.selectedCategory
        }
    }
    
    
}


// MARK: - tableView delegate
extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomViewCell
        
        if let item = toDoItems?[indexPath.row] {
            cell.label.text = item.title
            cell.pointLabel.text = String(item.getPoint)
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showDeleteWarning(for: indexPath)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func Calculation(for indexPath: IndexPath) {
        //currentPointに値を入れる
        if let item = toDoItems?[indexPath.row] {
            
            let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
            
            currentPoint = savedNumber + item.getPoint
            
        }
        //currentPointをuserDefalutsに保存
        UserDefaults.standard.set(currentPoint, forKey: "currentValue")
        //currentPointをnavBarに表示
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        totalPointDisplay.title = String(savedNumber)
    }
}

// MARK: - instructions
extension ListViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "このボタンで目標達成までに行なうスモールタスクを設定できます"
            coachViews.bodyView.nextLabel.text = "OK"
            
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

