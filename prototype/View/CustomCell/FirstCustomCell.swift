//
//  FirstCustomCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/17.
//

import UIKit

class FirstCustomCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        colorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
