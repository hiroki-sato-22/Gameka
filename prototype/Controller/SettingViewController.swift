//
//  SettingViewController.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/28.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTableView()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .systemBackground
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell2")
    }
    
}


extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle: NSArray = [
            "アプリ",
            "その他",
        ]
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .systemBackground
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! SettingTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.label.text = "ダークモード"
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
            
        }else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! SettingTableViewCell
            cell.label.text = "プライバシーポリシー"
            cell.uiSwitch.isHidden = true
            cell.label.textColor = .link
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as!SettingTableViewCell
            cell.label.text = "サポート"
            cell.label.textColor = .link
            cell.uiSwitch.isHidden = true
            cell.backgroundColor = .secondarySystemBackground
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            return
        }else if indexPath.row == 0 {
            
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

