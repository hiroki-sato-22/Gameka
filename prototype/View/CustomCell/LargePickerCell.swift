//
//  LargePickerCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/27.
//

import UIKit

class LargePickerCell: UITableViewCell {

    @IBOutlet weak var picker: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
