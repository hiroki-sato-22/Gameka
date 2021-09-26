//
//  BaseViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/26.
//

import UIKit
import RealmSwift
import ChameleonFramework

class BaseViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.frame.height / 10
        tableView.separatorStyle = .none
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

}
