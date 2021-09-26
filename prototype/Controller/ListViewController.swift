//
//  ListViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit
import RealmSwift
import Instructions
import ChameleonFramework

class ListViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointLabel: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let coachMarksController = CoachMarksController()
    var currentPoint = 0
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    let userDefaults = UserDefaults.standard
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.coachMarksController.dataSource = self
        firstLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedNumber = userDefaults.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
        tableView.reloadData()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.frame.height / 9
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        tableView.separatorStyle = .none
    }
    
    func firstLaunch() {
        let launchList = userDefaults.bool(forKey: "launchList")
        if launchList == true {
            return
        } else {
            userDefaults.set(true, forKey: "launchList")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
        let savedNumber = userDefaults.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
  
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
    
    func showDeleteWarning(for indexPath: IndexPath) {

        let alert = UIAlertController(title: "タスクを完了しますか？", message: "OKを選択するとポイントが加算されます", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.Calculation(for: indexPath)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToEditSmallTasks", sender: nil)
    }
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditSmallTasks" {
            
            let nav = segue.destination as! UINavigationController
            
            let destinationVC = nav.topViewController as! EditTaskViewController
            destinationVC.selectedCategory = self.selectedCategory
        }
        
        if segue.identifier == "goToEditPoint" {
            
            let nav = segue.destination as! UINavigationController
            
            let destinationVC = nav.topViewController as! EditPointViewController
            destinationVC.pickerValue = userDefaults.integer(forKey: "currentValue")
        }
        
    }
    
    func Calculation(for indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            let savedNumber = userDefaults.integer(forKey: "currentValue")
            currentPoint = savedNumber + item.getPoint
        }
        userDefaults.set(currentPoint, forKey: "currentValue")
        let savedNumber = userDefaults.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
}


// MARK: - tableView delegate
extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.icon.image = UIImage(systemName: "circle")
        cell.colorView.layer.cornerRadius = 20
        
        let color = UIColor.systemTeal
        
        if let colour = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
            cell.colorView.backgroundColor = colour
            cell.icon.tintColor = ContrastColorOf(colour, returnFlat: true)
            cell.pointLabel.textColor = ContrastColorOf(colour, returnFlat: true)
            cell.label.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        if let item = toDoItems?[indexPath.row] {
            cell.label.text = item.title
            cell.pointLabel.text = String(item.getPoint)
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
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
    
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        if indexPath.section == 0 { return false }
    //        return true
    //    }
    
    
}


extension ListViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: false,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "このボタンでタスクを追加できます"
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


