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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
