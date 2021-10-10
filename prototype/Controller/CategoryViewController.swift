//
//  CategoryViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit
import RealmSwift
import Instructions
import ChameleonFramework

class CategoryViewController: UIViewController{
    
    @IBOutlet weak var pointLabel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addGoal: UIBarButtonItem!
    
    let coachMarksController = CoachMarksController()
    let realm = try! Realm()
    var titleString: String?
    var categories: Results<Category>?
    let userDefaults = UserDefaults.standard
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        loadCategories()
        view.backgroundColor = .systemBackground
        notifi()
        self.coachMarksController.dataSource = self
        setSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedNumber = UserDefaults.standard.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    func setSearchController(){
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    //継承
    func firstLaunch() {
        let launchCategory = userDefaults.bool(forKey: "launchCategory")
        if launchCategory {
            return
        } else {
            userDefaults.set(true, forKey: "launchCategory")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    @objc override func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
        let savedNumber = userDefaults.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    //継承
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
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "goToEdit", sender: nil)
    }
    
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
            destinationVC.title = titleString
        }
        
        if segue.identifier == "goToEditPoint" {
            
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! EditPointViewController
            destinationVC.pickerValue = userDefaults.integer(forKey: "currentValue")
        }
    }
    
    
}

extension CategoryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.label.text = categories?[indexPath.row].name ?? "No Categories added yet"
        cell.pointLabel.isHidden = true
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let color = UIColor.systemTeal
        if let colour = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(categories!.count)) {
            cell.backgroundColor = colour
            cell.icon.tintColor = ContrastColorOf(colour, returnFlat: true)
            cell.label.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        removeUnderLine(indexPath: indexPath, cell: cell)
        return cell
        
        
    }
    
    
    func removeUnderLine(indexPath: IndexPath, cell: UITableViewCell){
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        if (indexPath.row == lastRowIndex - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
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

extension CategoryViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController
    ) {
        categories = categories?.filter("name CONTAINS[cd] %@", searchController.searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
        if searchController.searchBar.text?.count == 0 {
            loadCategories()
        }
    }
    
}

extension CategoryViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: false,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "このボタンでカテゴリーを追加できます"
            coachViews.bodyView.separator.isHidden = true
            coachViews.bodyView.background.borderColor = .clear
            
        case 1:
            coachViews.bodyView.hintLabel.text = "数字をタップすると所持ポイントを編集できます"
            coachViews.bodyView.separator.isHidden = true
            coachViews.bodyView.background.borderColor = .clear
            
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

