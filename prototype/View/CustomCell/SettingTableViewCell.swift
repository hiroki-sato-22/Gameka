//
//  SettingTableViewCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/28.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    var DarkisOn = Bool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uiSwitch.isOn = userDefaults.bool(forKey: "mySwitchValue")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        
        if ( (sender as AnyObject).isOn ) {
            DarkisOn = true
            userDefaults.setValue(DarkisOn, forKey: "darkIsOn")
            window?.overrideUserInterfaceStyle = .dark
        } else {
            DarkisOn = false
            userDefaults.setValue(DarkisOn, forKey: "darkIsOn")
            window?.overrideUserInterfaceStyle = .light
        }
        
        print(DarkisOn)
        userDefaults.set((sender as AnyObject).isOn, forKey: "mySwitchValue")
    }
    
}


