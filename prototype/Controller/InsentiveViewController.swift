//
//  InsentiveViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/16.
//

import UIKit
import RealmSwift
import Instructions
import ChameleonFramework

class InsentiveViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var pointLabel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let coachMarksController = CoachMarksController()
    let realm = try! Realm()
    let userDefaults = UserDefaults.standard
    var insentives: Results<Insentive>?
    var currentPoint = 0
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadInsentives()
        setTableView()
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
        let savedNumber = userDefaults.integer(forKey: "currentValue")
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
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.separatorStyle = .none
    }
    
    @objc override func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
        let savedNumber = userDefaults.integer(forKey: "currentValue")
        pointLabel.title = String(savedNumber)
    }
    
    func loadInsentives() {
        insentives = realm.objects(Insentive.self)
        tableView.reloadData()
    }
    
    func firstLaunch() {
        let launchInsentive = userDefaults.bool(forKey: "launchInsentive")
        if launchInsentive == true {
            return
        } else {
            userDefaults.set(true, forKey: "launchInsentive")
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    func Calculation(for indexPath: IndexPath) {
        
        if let item = insentives?[indexPath.row] {
            let savedNumber = userDefaults.integer(forKey: "currentValue")
            currentPoint = savedNumber - item.point
        }
        userDefaults.set(currentPoint, forKey: "currentValue")
        let savedNumber = userDefaults.integer(forKey: "currentValue")
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
    
    func showDeleteWarning(for indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "ご褒美を実行しますか？", message: "OKを選択すると所持ポイントから減算されます", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.Calculation(for: indexPath)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToEditInsentives", sender: nil)
    }
    
    @IBAction func pointPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditPoint", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditPoint" {
            
            let nav = segue.destination as! UINavigationController
            
            let destinationVC = nav.topViewController as! EditPointViewController
            destinationVC.pickerValue = userDefaults.integer(forKey: "currentValue")
        }
    }
    
}

extension InsentiveViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return insentives?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let item = insentives?[indexPath.row] {
            
            cell.label.text = item.title
            cell.pointLabel.text = String(item.point)
        }
        
        let color = UIColor.systemTeal
        if let colour = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(insentives!.count)) {
            cell.backgroundColor = colour
            cell.icon.tintColor = ContrastColorOf(colour, returnFlat: true)
            cell.pointLabel.textColor = ContrastColorOf(colour, returnFlat: true)
            cell.label.textColor = ContrastColorOf(colour, returnFlat: true)
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
    
}

extension InsentiveViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController
    ) {
        insentives = insentives?.filter("title CONTAINS[cd] %@", searchController.searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
        if searchController.searchBar.text?.count == 0 {
            loadInsentives()
            
        }
    }
    
}


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

