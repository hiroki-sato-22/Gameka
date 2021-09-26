//
//  SecondCustomCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/17.
//

import UIKit

class SecondCustomCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
