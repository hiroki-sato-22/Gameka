//
//  PickerViewCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/23.
//

import UIKit

class PickerViewCell: UITableViewCell {

    @IBOutlet weak var picker: UIPickerView!
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
