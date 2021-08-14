//
//  CategoryViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit
import RealmSwift
import Instructions

class CategoryViewController: UIViewController{
    
    @IBOutlet weak var pointLabel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addGoal: UIBarButtonItem!
    
    let realm = try! Realm()
    var titleString: String?
    var categories: Results<Category>?
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        self.coachMarksController.dataSource = self
        firstLaunch()
        setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //pointLabelに表示
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    
    func firstLaunch() {
        let launchCategory = UserDefaults.standard.bool(forKey: "launchCategory")
        if launchCategory == true {
            return
        } else {
            UserDefaults.standard.set(true, forKey: "launchCategory")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
  
    
    // MARK: - data
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    // MARK: - action
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "goToEdit", sender: nil)
    }
    
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
            destinationVC.title = titleString
        }
    }
    
    
}

// MARK: - tableView delegate
extension CategoryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomViewCell
        cell.label.text = categories?[indexPath.row].name ?? "No Categories added yet"
        cell.pointLabel.isHidden = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        titleString = categories?[indexPath.row].name
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

// MARK: - instructions
extension CategoryViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "このボタンで目標を追加できます"
            coachViews.bodyView.nextLabel.text = "OK"
            
        case 1:
            coachViews.bodyView.hintLabel.text = "数字をタップすると所持ポイントを編集できます"
            coachViews.bodyView.nextLabel.text = "OK"
            
        default:
            break
            
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [
            addGoal.value(forKey: "view") as! UIView,
            pointLabel.value(forKey: "view") as! UIView,
        ]
        
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    
}

