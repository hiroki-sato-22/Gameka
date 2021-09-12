//
//  SettingViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/28.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = view.frame.height / 9
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeight.constant = view.frame.height / 3
    }

}



extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! SettingTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.label.text = "ダークモード"
            

            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! SettingTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.label.text = "プライバシーポリシー"
            cell.uiSwitch.isHidden = true
            cell.label.textColor = .link

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as!SettingTableViewCell
            cell.label.text = "サポート"
            cell.label.textColor = .link
            cell.uiSwitch.isHidden = true
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            return
        }else if indexPath.row == 1 {
            
            let url = NSURL(string: "https://hiroki-sato-dev.hatenablog.com/entry/2021/08/08/105747")
                    if UIApplication.shared.canOpenURL(url! as URL) {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    }
        }else {
            
            let url = NSURL(string: "https://twitter.com/sato91939961")
                    if UIApplication.shared.canOpenURL(url! as URL) {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    }
        }
        
    }
    
    
}

